class AddRejectedReasonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rejected_reason, :text
  end
end
