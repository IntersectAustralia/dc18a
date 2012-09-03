# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experiment do
    expt_name "My Experiment"
    expt_type "Fixed"
    association :user, :factory => :user
    association :project, :factory => :project
  end
end
