class AddExtraAttrsToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :slides, :boolean
    add_column :experiments, :dishes, :boolean
    add_column :experiments, :multiwell_chambers, :boolean
    add_column :experiments, :other, :boolean
    add_column :experiments, :other_text, :string
    add_column :experiments, :reporter_protein, :boolean
    add_column :experiments, :reporter_protein_text, :string
    add_column :experiments, :specific_dyes, :boolean
    add_column :experiments, :specific_dyes_text, :string
    add_column :experiments, :immunofluorescence, :boolean
    add_column :experiments, :created_date, :datetime
  end
end
