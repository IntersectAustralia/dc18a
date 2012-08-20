class AddApprovedDateTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved_on, :datetime
  end
end
