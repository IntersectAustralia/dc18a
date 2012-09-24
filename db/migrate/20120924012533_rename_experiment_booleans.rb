class RenameExperimentBooleans < ActiveRecord::Migration
  def change
    rename_column :experiments, :specific_dyes, :has_specific_dyes
    rename_column :experiments, :fluorescent_protein, :has_fluorescent_proteins

  end
end
