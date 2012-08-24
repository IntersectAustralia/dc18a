# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experiment do
    name "MyString"
    type ""
    lab_book_no "MyString"
    page_no "MyString"
    cell_type_or_tissue "MyString"
  end
end
