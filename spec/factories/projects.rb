# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "MyString"
    description "MyString"
    funded_by_agency false
    agency "MyString"
    other_agency "MyString"
  end
end
