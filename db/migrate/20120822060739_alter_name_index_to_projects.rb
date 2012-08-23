class AlterNameIndexToProjects < ActiveRecord::Migration
  def change
    remove_index :projects, :name
    add_index :projects, :name
  end
end
