class AddExperimentsImmunofluorescences < ActiveRecord::Migration
  def up
    create_table :experiments_immunofluorescences do |t|
      t.references :experiment
      t.references :immunofluorescence
    end
  end

  def down
    drop_table :experiments_immunofluorescences
  end
end
