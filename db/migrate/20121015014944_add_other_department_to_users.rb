class AddOtherDepartmentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_department, :string
  end
end
