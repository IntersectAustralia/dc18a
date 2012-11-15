class AlterColumnTypeToEditors < ActiveRecord::Migration
  def up
    change_column :editors, :text, :text
  end

  def down
    change_column :editors, :text, :string
  end
end
