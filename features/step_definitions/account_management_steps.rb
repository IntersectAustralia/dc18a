Given /^I have access requests$/ do |table|
  supervisor_role = Role.find_by_name("Supervisor")
  supervisor_1 = FactoryGirl.create(:user, :role => supervisor_role, :status => "A")
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'U', :supervisors => [supervisor_1]))
  end
end

Given /^I have users$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'A'))
  end
end

Given /^I have administrators$/ do |table|
  administrator_role = Role.find_by_name("Administrator")
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'A', :role => administrator_role))
  end
end

Given /^I have supervisors$/ do |table|
  supervisor_role = Role.find_by_name("Supervisor")
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'A', :role => supervisor_role))
  end
end

Given /^I have researchers$/ do |table|
  researcher_role = Role.find_by_name("Researcher")
  supervisor_role = Role.find_by_name("Supervisor")
  supervisor_1 = FactoryGirl.create(:user, :role => supervisor_role, :status => "A")
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'A', :role => researcher_role, :supervisors => [supervisor_1]))
  end
end

Given /^I have roles$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:role, hash)
  end
end

And /^I have role "([^"]*)"$/ do |name|
  FactoryGirl.create(:role, :name => name)
end


Given /^I have permissions$/ do |table|
  table.hashes.each do |hash|
    create_permission_from_hash(hash)
  end
end

def create_permission_from_hash(hash)
  roles = hash[:roles].split(",")
  create_permission(hash[:entity], hash[:action], roles)
#  create_permission(hash[:entity], hash[:action], hash[:roles])
end

def create_permission(entity, action, roles)
  permission = Permission.new(:entity => entity, :action => action)
  permission.save!
  roles.each do |role_name|
    role = Role.where(:name => role_name).first
    role.permissions << permission
    role.save!
  end
end

Given /^"([^"]*)" has role "([^"]*)"$/ do |user_id, role|
  user = User.where(:user_id => user_id).first
  role = Role.where(:name => role).first
  user.role = role
  user.save!(:validate => false)
end

When /^I follow "Approve" for "([^"]*)"$/ do |user_id|
  user = User.where(:user_id => user_id).first
  click_link("approve_#{user.id}")
end

When /^I follow "Reject" for "([^"]*)"$/ do |user_id|
  user = User.where(:user_id => user_id).first
  click_link("reject_reason_#{user.id}")
end

When /^I follow "Reject as Spam" for "([^"]*)"$/ do |user_id|
  user = User.where(:user_id => user_id).first
  click_link("reject_as_spam_#{user.id}")
end

When /^I follow "View Details" for "([^"]*)"$/ do |user_id|
  user = User.where(:user_id => user_id).first
  click_link("view_#{user.id}")
end

When /^I follow "Edit role" for "([^"]*)"$/ do |user_id|
  user = User.where(:user_id => user_id).first
  click_link("edit_role_#{user.id}")
end

Given /^"([^"]*)" is deactivated$/ do |user_id|
  user = User.where(:user_id => user_id).first
  user.deactivate
end

Given /^"([^"]*)" is pending approval$/ do |user_id|
  user = User.where(:user_id => user_id).first
  user.status = "U"
  user.save!
end

Given /^"([^"]*)" is rejected as spam$/ do |user_id|
  user = User.where(:user_id => user_id).first
  user.reject_access_request
end
