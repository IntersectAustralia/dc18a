class AddExperimentSpecificDyes < ActiveRecord::Migration
  def up
    create_table :experiments_specific_dyes do |t|
      t.references :experiment
      t.references :specific_dye
    end
  end

  def down
    drop_table :experiments_specific_dyes
  end
end
