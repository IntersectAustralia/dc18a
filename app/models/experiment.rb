class Experiment < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  attr_accessible :cell_type_or_tissue, :lab_book_no, :expt_name, :page_no, :expt_type, :project_id,
                  :slides, :dishes, :multiwell_chambers, :other, :other_text, :fluorescent_protein, :fluorescent_protein_ids,
                  :specific_dyes, :specific_dyes_text, :immunofluorescence, :created_date, :instrument

  has_and_belongs_to_many :fluorescent_proteins

  validates_length_of :expt_name, :maximum => 255
  validates_length_of :lab_book_no, :maximum => 255
  validates_length_of :page_no, :maximum => 255
  validates_length_of :cell_type_or_tissue, :maximum => 255
  validates_length_of :other_text, :maximum => 255
  validates_length_of :specific_dyes_text, :maximum => 255
  validates_presence_of :expt_name
  validates_presence_of :lab_book_no
  validates_presence_of :page_no
  validates_presence_of :cell_type_or_tissue
  validates_presence_of :expt_type
  validates_presence_of :other_text, :if => :other?, :message => '"Other (Specify)" cannot be empty if "Other" is checked'
  validates_presence_of :fluorescent_protein_ids, if: :fluorescent_protein?, message: "can't be empty if 'Fluorescent protein' is checked"
  validates_presence_of :specific_dyes_text, :if => :specific_dyes?, :message => '"Specific Dyes (Specify)" cannot be empty if "Specific Dyes" is checked'

  before_save :assign_experiment_id

  def created_date
    self.created_at.localtime.strftime("%d/%m/%Y")
  end

  private

  def assign_experiment_id
    self.expt_id = self.project.experiments.count + 1
  end

end
