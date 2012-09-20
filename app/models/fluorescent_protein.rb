class FluorescentProtein < ActiveRecord::Base
  attr_accessible :name, :core

  scope :core, where(core: true)
end
