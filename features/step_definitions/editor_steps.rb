And /^I have editors$/ do |table|
  table.hashes.each do |attributes|
    FactoryGirl.create(:editor, :name => attributes['name'],
                       :text => attributes['text'])
  end
end
