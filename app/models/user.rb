class User < ActiveRecord::Base
  # Include devise modules
  devise :ldap_authenticatable, :registerable, :lockable, :recoverable, :trackable, :validatable, :timeoutable

  belongs_to :role
  has_and_belongs_to_many :supervisors, :class_name => "User", :association_foreign_key => "supervisor_id", :join_table => 'supervisors_users'
  has_many :projects
  has_many :experiments

  # Setup accessible attributes (status/approved flags should NEVER be accessible by mass assignment)
  attr_accessible :user_id, :email, :password, :password_confirmation, :first_name, :last_name, :department, :other_department, :supervisor_ids

  validates_presence_of :user_id
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :status
  validates_presence_of :department
  validates_presence_of :other_department, :if => Proc.new { |user| user.department == "Other (Specify)" }
  validates_presence_of :supervisor_ids, :unless => Proc.new {|user| user.administrator? || user.supervisor?}

  validates_length_of :user_id, :maximum => 32
  validates_length_of :first_name, :maximum => 32
  validates_length_of :last_name, :maximum => 32
  validates_length_of :email, :maximum => 255
  validates_length_of :department, :maximum => 255
  validates_length_of :other_department, :maximum => 255

  validates_uniqueness_of :user_id

  with_options :if => :password_required? do |v|
    v.validates :password, :password_format => true
  end

  validate :project_has_supervisor, :on => :update

  before_validation :initialize_status

  scope :pending_approval, where(:status => 'U').order(:user_id)
  scope :approved, where(:status => 'A').order(:user_id)
  scope :deactivated_or_approved, where("status = 'D' or status = 'A' ").order(:user_id)
  scope :approved_superusers, joins(:role).merge(User.approved).merge(Role.superuser_roles)
  scope :can_supervise, joins(:role).merge(Role.supervisor_roles).merge(User.approved)

  # Override Devise active for authentication method so that users must be approved before being allowed to log in
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
  def active_for_authentication?
    super && approved?
  end

  # Override Devise method so that user is actually notified right after the third failed attempt.
  def attempts_exceeded?
    self.failed_attempts >= self.class.maximum_attempts
  end

  # Overrride Devise method so we can check if account is active before allowing them to get a password reset email
  def send_reset_password_instructions
    if approved?
      generate_reset_password_token!
      ::Devise.mailer.reset_password_instructions(self).deliver
    else
      if pending_approval? or deactivated?
        Notifier.notify_user_that_they_cant_reset_their_password(self).deliver
      end
    end
  end

  # Custom method overriding update_with_password so that we always require a password on the update password action
  # Devise expects the update user and update password to be the same screen so accepts a blank password as indicating that
  # the user doesn't want to change it
  def update_password(params={})
    current_password = params.delete(:current_password)

    result = if valid_password?(current_password)
               update_attributes(params)
             else
               self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               self.attributes = params
               false
             end

    clean_up_passwords
    result
  end

  # Override devise method that resets a forgotten password, so we can clear locks on reset
  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation
    clear_reset_password_token if valid?
    if valid?
      unlock_access! if access_locked?
    end
    save
  end


  def approved?
    self.status == 'A'
  end

  def pending_approval?
    self.status == 'U'
  end

  def deactivated?
    self.status == 'D'
  end

  def rejected?
    self.status == 'R'
  end

  def deactivate
    self.status = 'D'
    save!(:validate => false)
  end

  def activate
    self.status = 'A'
    save!(:validate => false)
  end

  def approve_access_request
    self.status = 'A'
    self.approved_on = Time.new
    save!(:validate => false)

    # send an email to the user
    Notifier.notify_user_of_approved_request(self).deliver
  end

  def reject_access_request(reason)
    self.status = 'R'
    self.rejected_reason = reason
    save!(:validate => false)

    # send an email to the user
    Notifier.notify_user_of_rejected_request(self).deliver
  end

  def notify_admin_by_email
    Notifier.notify_superusers_of_access_request(self).deliver
  end

  def check_number_of_superusers(id, current_user_id)
    current_user_id != id.to_i or User.approved_superusers.length >= 2
  end

  def self.get_superuser_emails
    approved_superusers.collect { |u| u.email }
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def supervisors_list
    list = supervisors.collect { |u| u.full_name }
    if list.empty?
      return "N/A"
    end
    list.to_sentence
  end

  def administrator?
    self.role == Role.find_by_name('Administrator')
  end

  def supervisor?
    self.role == Role.find_by_name('Supervisor')
  end

  def researcher?
    self.role == Role.find_by_name('Researcher')
  end

  def add_supervisor(user)
    self.supervisors << user if user.administrator? or user.supervisor?
  end

  alias_method :original_projects, :projects
  def projects
    if self.administrator?
      Project.scoped
    elsif self.supervisor?
      Project.supervised_by(self)
    else
      self.original_projects
    end
  end

  def project_has_supervisor
    supervisors_can_not_be_removed = Set.new

    self.original_projects.each do |p|
      if !self.supervisors.include?(p.supervisor)
        supervisors_can_not_be_removed.add(p.supervisor)
      end
    end

    supervisors_can_not_be_removed.each do |s|
      errors.add(:supervisors, "#{s.full_name} cannot be removed from supervisor list as they are a supervisor for one or more of the users projects.")
    end

  end

  private

  def initialize_status
    self.status = "U" unless self.status
  end

end
