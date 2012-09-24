class RemoveExperimentTexts < ActiveRecord::Migration
  def change
    remove_column :experiments, :specific_dyes_text
    remove_column :experiments, :fluorescent_protein_text
  end

end
