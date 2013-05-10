class Experiment < ActiveRecord::Base

  belongs_to :user
  belongs_to :project
  belongs_to :experiment_feedback

  attr_accessible :cell_type_or_tissue, :lab_book_no, :expt_name, :page_no, :expt_type, :project_id ,
                  :slides, :dishes, :multiwell_chambers, :other, :other_text, :has_fluorescent_proteins, :fluorescent_protein_ids,
                  :has_specific_dyes, :specific_dye_ids, :has_immunofluorescence, :immunofluorescence_ids, :created_date, :instrument, :user_id

  has_and_belongs_to_many :fluorescent_proteins
  has_and_belongs_to_many :specific_dyes
  has_and_belongs_to_many :immunofluorescences

  validates_length_of :expt_name, :maximum => 255
  validates_length_of :lab_book_no, :maximum => 255
  validates_length_of :page_no, :maximum => 255
  validates_length_of :cell_type_or_tissue, :maximum => 255
  validates_length_of :other_text, :maximum => 255
  validates_presence_of :expt_name
  #validates_presence_of :lab_book_no
  #validates_presence_of :page_no
  validates_presence_of :cell_type_or_tissue
  validates_presence_of :expt_type
  validates_presence_of :other_text, :if => :other?, :message => '"Other (Specify)" cannot be empty if "Other" is checked'
  validates_presence_of :fluorescent_protein_ids, if: :has_fluorescent_proteins?, message: "can't be empty if 'Fluorescent proteins' is checked"
  validates_presence_of :specific_dye_ids, if: :has_specific_dyes?, message: "can't be empty if 'Specific dyes' is checked"
  validates_presence_of :immunofluorescence_ids, if: :has_immunofluorescence?, message: "can't be empty if 'Secondary Antibodies' is checked"

  before_save :assign_experiment_id

  def created_date
    self.created_at.localtime.strftime("%d/%m/%Y")
  end

  def assign_end_time
    self.end_time = DateTime.now
    save!
  end

  def expt_duration
    expt_start = self.created_at.localtime.strftime('%Y-%m-%d %H:%M')
    expt_end = self.end_time.localtime.strftime('%Y-%m-%d %H:%M')
    duration = Time.diff(Time.parse(expt_start), Time.parse(expt_end))

  end

  private

  def assign_experiment_id
    self.expt_id = self.project.experiments.count + 1
  end

end
