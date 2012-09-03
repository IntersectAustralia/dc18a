class AddInstrumentToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :instrument, :string
  end
end
