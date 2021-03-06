class Ability
  include CanCan::Ability

  def initialize(user, ip = nil)
    # alias edit_role to update_role so that they don't have to be declared separately
    alias_action :edit_role, :to => :update_role
    alias_action :edit_approval, :to => :approve

    # alias activate and deactivate to "activate_deactivate" so its just a single permission
    alias_action :deactivate, :to => :activate_deactivate
    alias_action :activate, :to => :activate_deactivate

    # alias access_requests to view_access_requests so the permission name is more meaningful
    alias_action :access_requests, :to => :admin

    # alias reject_as_spam to reject so they are considered the same
    alias_action :reject_as_spam, :to => :reject

    # alias reject_reason to reject so they are considered the same
    alias_action :reject_reason, :to => :reject

    return unless user.role

    if user.administrator?
      can :manage, [Project, Editor, User]
    end

    # User can manage projects they own or they are supervisor of
    can :manage, Project do |project|
      user.projects.include?(project)
    end

    if user.administrator?
      can :summary, Project
    else
      cannot :summary, Project
    end

    # User can create/edit experiments only in lab
    ip_addresses = INSTRUMENTS.keys

    if ip_addresses.include?(ip)
      can [:new, :cancel], Experiment
      can [:edit, :update, :cancel_update], Experiment, :end_time => nil, :user_id => user.id
      can [:show, :download], Experiment do |experiment|
        user.projects.include?(experiment.project)
      end
    else
      can [:show, :download], Experiment do |experiment|
        user.projects.include?(experiment.project)
      end
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
