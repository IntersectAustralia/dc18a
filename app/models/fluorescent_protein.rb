class FluorescentProtein < ActiveRecord::Base
  attr_accessible :name, :core

  scope :core, where(core: true)

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
