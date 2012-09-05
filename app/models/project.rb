class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :supervisor, :class_name => "User", :foreign_key => "supervisor_id"

  attr_accessible :agency, :description, :funded_by_agency, :name, :other_agency, :supervisor_id, :user_id
  has_many :experiments

  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 255
  validates_length_of :other_agency, :maximum => 255
  validates_presence_of :name, :supervisor_id
  validates_presence_of :agency, :if => Proc.new { |project| project.funded_by_agency? }
  validates_presence_of :other_agency, :if => Proc.new { |project| project.funded_by_agency? && project.agency == "Other" }

  scope :supervised_by, lambda { |supervisor| joins(:supervisor).where("projects.user_id = '#{supervisor.id}' or users.user_id = '#{supervisor.user_id}'") }

  def to_json_data
    funded_by = 'N/A'
    if self.agency
      funded_by = self.agency
    end
    { "project_id" => self.id,
      "description" => self.description,
      "date_created" => self.created_at.localtime.strftime("%d/%m/%Y"),
      "supervisor" => User.find_by_id(self.supervisor_id).full_name,
      "funded_by" => funded_by }.to_json
  end

  def created_date
    self.created_at.localtime.strftime("%d/%m/%Y")
  end
end
