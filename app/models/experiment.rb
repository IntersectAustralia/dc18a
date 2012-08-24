class Experiment < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  attr_accessible :cell_type_or_tissue, :lab_book_no, :name, :page_no, :type
end
