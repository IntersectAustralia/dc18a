class CreateSupervisorsUsers < ActiveRecord::Migration
  def change
    create_table :supervisors_users, :id => false do |t|
      t.integer :supervisor_id
      t.integer :user_id
    end
  end
end
