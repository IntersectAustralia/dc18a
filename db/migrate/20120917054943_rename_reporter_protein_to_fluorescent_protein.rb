class RenameReporterProteinToFluorescentProtein < ActiveRecord::Migration
  def change
    rename_column :experiments, :reporter_protein, :fluorescent_protein
    rename_column :experiments, :reporter_protein_text, :fluorescent_protein_text

  end

end
