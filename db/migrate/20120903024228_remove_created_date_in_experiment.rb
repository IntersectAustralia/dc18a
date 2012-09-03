class RemoveCreatedDateInExperiment < ActiveRecord::Migration
  def up
    remove_column :experiments, :created_date
  end

  def down
    add_column :experiments, :created_date, :datetime
  end
end
