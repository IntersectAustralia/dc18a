class Experiment < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  attr_accessible :cell_type_or_tissue, :lab_book_no, :expt_name, :page_no, :expt_type, :project_id ,
                  :slides, :dishes, :other, :other_text, :reporter_protein, :reporter_protein_text,
                  :specific_dyes, :specific_dyes_text, :immunofluorescence, :created_date
end
