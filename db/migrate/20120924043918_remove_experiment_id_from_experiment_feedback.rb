class RemoveExperimentIdFromExperimentFeedback < ActiveRecord::Migration
  def up
    remove_column :experiment_feedbacks, :experiment_id
  end

  def down
    add_column :experiment_feedbacks, :experiment_id, :integer
  end
end
