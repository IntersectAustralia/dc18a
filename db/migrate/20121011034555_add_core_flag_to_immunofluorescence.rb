class AddCoreFlagToImmunofluorescence < ActiveRecord::Migration
  def change
    add_column :immunofluorescences, :core, :boolean
  end
end
