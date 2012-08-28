class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :supervisor, :class_name => "User", :foreign_key => "supervisor_id"

  attr_accessible :agency, :description, :funded_by_agency, :name, :other_agency, :supervisor_id, :user_id

  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 255
  validates_length_of :other_agency, :maximum => 255
  validates_presence_of :name, :supervisor_id
  validates_presence_of :agency, :if => Proc.new { |project| project.funded_by_agency? }
  validates_presence_of :other_agency, :if => Proc.new { |project| project.funded_by_agency? && project.agency == "Other" }

  scope :supervised_by, lambda { |supervisor| joins(:supervisor).where("projects.user_id = '#{supervisor.id}' or users.user_id = '#{supervisor.user_id}'") }
end
