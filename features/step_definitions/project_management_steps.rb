Given /^"([^"]*)" has (\d+) projects$/ do |user_id, count|
  user = User.find_by_user_id(user_id)
  supervisor = user.supervisors.first
  count.to_i.times do
    FactoryGirl.create(:project, :user => user, :supervisor => supervisor)
  end
end

Given /^"([^"]*)" has projects$/ do |user_id, table|
  user = User.find_by_user_id(user_id)
  default_supervisor = user.supervisors.first

  table.hashes.each do |hash|
    supervisor = hash[:supervisor].nil? ? default_supervisor : User.find_by_user_id(hash[:supervisor])
    FactoryGirl.create(:project, :user => user, :supervisor => supervisor, :name => hash[:name])
  end
end

Given /^"([^"]*)" of "([^"]*)" should not be set$/ do |attr, proj_name|
  project = Project.find_by_name(proj_name)
  project[attr].should == nil
end

Given /^I have no projects$/ do
  Project.delete_all
end

And /^I have projects$/ do |table|
  table.hashes.each do |attributes|
    user = User.find_by_user_id attributes['owner']
    supervisor = User.find_by_user_id attributes['supervisor']
    FactoryGirl.create(:project, :name => attributes['project_name'], :description => attributes['description'],
                       :funded_by_agency => attributes['funded_by_agency'], :agency => attributes['funded_by'],
                       :user => user, :supervisor => supervisor)
  end
end

