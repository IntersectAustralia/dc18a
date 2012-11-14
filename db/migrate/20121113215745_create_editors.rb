class CreateEditors < ActiveRecord::Migration
  def change
    create_table :editors do |t|
      t.string :name
      t.string :text

      t.timestamps
    end
    add_index :editors, :name, :unique => true
  end
end
