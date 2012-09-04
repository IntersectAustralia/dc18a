class AddIndexToExperimentsExptName < ActiveRecord::Migration
  def change
    add_index :experiments, :expt_name
  end
end
