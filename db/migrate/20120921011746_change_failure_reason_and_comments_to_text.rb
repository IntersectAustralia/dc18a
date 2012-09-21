class ChangeFailureReasonAndCommentsToText < ActiveRecord::Migration
  def up
    change_column :experiment_feedbacks, :instrument_failed_reason, :text
    change_column :experiment_feedbacks, :other_comments, :text
  end

  def down
    change_column :experiment_feedbacks, :instrument_failed_reason, :string
    change_column :experiment_feedbacks, :other_comments, :string
  end
end
