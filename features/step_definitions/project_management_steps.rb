Given /^"([^"]*)" has (\d+) projects$/ do |user_id, count|
  user = User.find_by_user_id(user_id)
  supervisor = user.supervisors.first
  count.to_i.times do
    FactoryGirl.create(:project, :user => user, :supervisor => supervisor)
  end
end

Given /^"([^"]*)" has projects$/ do |user_id, table|
  user = User.find_by_user_id(user_id)
  supervisor = user.supervisors.first

  table.hashes.each do |hash|
    FactoryGirl.create(:project, hash.merge(:user => user, :supervisor => supervisor))
  end
end

Given /^"([^"]*)" of "([^"]*)" should not be set$/ do |attr, proj_name|
  project = Project.find_by_name(proj_name)
  project[attr].should == nil
end
