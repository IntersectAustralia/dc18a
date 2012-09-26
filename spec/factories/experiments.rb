# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experiment do
    expt_name "My Experiment"
    lab_book_no "111"
    page_no "21"
    cell_type_or_tissue "Cell Type B"
    expt_type "Fixed"
    association :user, :factory => :user
    association :project, :factory => :project
    association :experiment_feedback, :factory => :experiment_feedback
  end
end
