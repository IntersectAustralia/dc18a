class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.boolean :funded_by_agency
      t.string :agency
      t.string :other_agency
      t.integer :user_id
      t.integer :supervisor_id

      t.timestamps
    end

    add_index :projects, :name, :unique => true

  end
end
