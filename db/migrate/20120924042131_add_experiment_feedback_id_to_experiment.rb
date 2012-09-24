class AddExperimentFeedbackIdToExperiment < ActiveRecord::Migration
  def up
    add_column :experiments, :experiment_feedback_id, :integer
  end

  def down
    remove_column :experiments, :experiment_feedback_id
  end
end
