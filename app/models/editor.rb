class Editor < ActiveRecord::Base
  attr_accessible :name, :text
  validates_presence_of :name
  validates_presence_of :text
  validates_length_of :text, :maximum => 512
end
