FactoryGirl.define do
  factory :user do |f|
    f.sequence(:user_id) { |n| "userid4user_#{n}" }
    f.first_name "Fred"
    f.last_name "Bloggs"
    f.password "Pas$w0rd"
    f.sequence(:email) { |n| "#{n}@intersect.org.au" }
    f.department "C3"
  end
end
