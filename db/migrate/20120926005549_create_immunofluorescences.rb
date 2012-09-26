class CreateImmunofluorescences < ActiveRecord::Migration
  def change
    create_table :immunofluorescences do |t|
      t.string :name
      t.timestamps
    end
  end
end
