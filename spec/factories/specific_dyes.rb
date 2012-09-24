# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :specific_dye do
    sequence(:name) { |n| "Dye #{n}" }
  end
end
