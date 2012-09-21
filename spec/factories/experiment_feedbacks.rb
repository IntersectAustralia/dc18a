# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experiment_feedback do
    experiment_failed true
    instrument_failed true
    instrument_failed_reason "Some Failure Reason"
    other_comments "Some Comments"
    association :experiment, :factory => :experiment
  end
end
