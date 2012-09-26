class RenameImmunofluorescenceFlag < ActiveRecord::Migration
  def change
    rename_column :experiments, :immunofluorescence, :has_immunofluorescence
  end
end
