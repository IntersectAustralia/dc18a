require 'spec_helper'

describe Project do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:supervisor) }
  end
end