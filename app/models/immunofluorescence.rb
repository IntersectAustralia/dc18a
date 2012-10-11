class Immunofluorescence < ActiveRecord::Base
  attr_accessible :name, :core

  validates :name, presence: true, uniqueness: true

  before_validation :squish_whitespace

  scope :core, where(core: true)

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { find_or_create_by_name($1).id }
    tokens.split(',')
  end

  def squish_whitespace
    name.squish!
  end
end
