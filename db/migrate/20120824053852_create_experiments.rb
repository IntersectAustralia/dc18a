class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.integer :expt_id
      t.string :expt_name
      t.string :expt_type
      t.string :lab_book_no
      t.string :page_no
      t.string :cell_type_or_tissue
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
