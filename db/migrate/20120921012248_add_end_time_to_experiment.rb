class AddEndTimeToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :end_time, :datetime
  end
end
