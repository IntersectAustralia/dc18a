class CreateExperimentFeedbacks < ActiveRecord::Migration
  def change
    create_table :experiment_feedbacks do |t|
      t.timestamps
      t.boolean :experiment_failed
      t.boolean :instrument_failed
      t.string :instrument_failed_reason
      t.string :other_comments
      t.integer :experiment_id
    end
  end
end
