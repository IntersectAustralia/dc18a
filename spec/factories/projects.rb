# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do |f|
    f.sequence(:name) { |n| "Test Project #{n}" }
    f.funded_by_agency false
    association :supervisor, :factory => :user
  end
end
