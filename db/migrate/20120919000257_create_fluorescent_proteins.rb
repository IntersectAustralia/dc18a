class CreateFluorescentProteins < ActiveRecord::Migration
  def change
    create_table :fluorescent_proteins do |t|
      t.string :name
      t.boolean :core, default: false, null: false
      t.timestamps
    end
  end
end
