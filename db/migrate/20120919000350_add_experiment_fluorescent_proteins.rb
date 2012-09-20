class AddExperimentFluorescentProteins < ActiveRecord::Migration
  def up
    create_table :experiments_fluorescent_proteins do |t|
      t.references :experiment
      t.references :fluorescent_protein
    end
  end

  def down
    drop_table :experiments_fluorescent_proteins
  end
end
