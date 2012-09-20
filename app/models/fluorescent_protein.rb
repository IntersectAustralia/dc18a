class FluorescentProtein < ActiveRecord::Base
  attr_accessible :name, :core

  scope :core, where(core: true)

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { find_or_create_by_name!($1).id }
    tokens.split(',')
  end
end
