class CreateSpecificDyes < ActiveRecord::Migration
  def change


    create_table :specific_dyes do |t|
      t.string :name
      t.timestamps
    end
  end
end
