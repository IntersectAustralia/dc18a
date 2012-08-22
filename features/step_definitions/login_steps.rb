Given /^I have a user "([^"]*)"$/ do |user_id|
  supervisor_role = Role.find_by_name("Supervisor")
  supervisor_1 = FactoryGirl.create(:user, :role => supervisor_role, :status => "A")
  FactoryGirl.create(:user, :user_id => user_id, :password => "Pas$w0rd", :status => 'A', :supervisors => [supervisor_1])
end

Given /^I have a user "([^"]*)" with email "([^"]*)"$/ do |user_id, email|
  FactoryGirl.create(:user, :user_id => user_id, :email => email, :password => "Pas$w0rd", :status => 'A')
end

Given /^I have a locked user "([^"]*)" with email "([^"]*)"$/ do |user_id, email|
  supervisor_role = Role.find_by_name("Supervisor")
  supervisor_1 = FactoryGirl.create(:user, :role => supervisor_role, :status => "A")
  FactoryGirl.create(:user, :user_id => user_id, :email => email, :password => "Pas$w0rd", :status => 'A', :locked_at => Time.now - 30.minute, :failed_attempts => 3, :supervisors => [supervisor_1])
end

Given /^I have a deactivated user "([^"]*)"$/ do |user_id|
  FactoryGirl.create(:user, :user_id => user_id, :password => "Pas$w0rd", :status => 'D')
end

Given /^I have a deactivated user "([^"]*)" with email "([^"]*)"$/ do |user_id, email|
  FactoryGirl.create(:user, :user_id => user_id, :email => email, :password => "Pas$w0rd", :status => 'D')
end

Given /^I have a rejected as spam user "([^"]*)"$/ do |user_id|
  supervisor_role = Role.find_by_name("Supervisor")
  supervisor_1 = FactoryGirl.create(:user, :role => supervisor_role, :status => "A")
  FactoryGirl.create(:user, :user_id => user_id, :password => "Pas$w0rd", :status => 'R', :supervisors => [supervisor_1])
end

Given /^I have a rejected as spam user "([^"]*)" with email "([^"]*)"$/ do |user_id, email|
  FactoryGirl.create(:user, :user_id => user_id, :email => email, :password => "Pas$w0rd", :status => 'R')
end

Given /^I have a pending approval user "([^"]*)"$/ do |user_id|
  FactoryGirl.create(:user, :user_id => user_id, :password => "Pas$w0rd", :status => 'U')
end

Given /^I have a pending approval user "([^"]*)" with email "([^"]*)"$/ do |user_id, email|
  FactoryGirl.create(:user, :user_id => user_id, :email => email, :password => "Pas$w0rd", :status => 'U')
end

Given /^I have a user "([^"]*)" with an expired lock$/ do |user_id|
  supervisor_role = Role.find_by_name("Supervisor")
  supervisor_1 = FactoryGirl.create(:user, :role => supervisor_role, :status => "A")
  FactoryGirl.create(:user, :user_id => user_id, :password => "Pas$w0rd", :status => 'A', :locked_at => Time.now - 1.hour - 1.second, :failed_attempts => 3, :supervisors => [supervisor_1])
end

Given /^I have a user "([^"]*)" with role "([^"]*)"$/ do |user_id, role|
  role         = Role.where(:name => role).first
  user         = FactoryGirl.create(:user, :user_id => user_id, :password => "Pas$w0rd", :status => 'A', :role => role)
  user.save!
end

Given /^I have a user "([^"]*)" with role "([^"]*)" with email "([^"]*)"$/ do |user_id, role, email|
  user            = FactoryGirl.create(:user, :user_id => user_id, :email => email, :password => "Pas$w0rd", :status => 'A')
  role         = Role.where(:name => role).first
  user.role_id = role.id
  user.save!
end

Given /^I am logged in as "([^"]*)"$/ do |user_id|
  visit path_to("the login page")
  fill_in("user_user_id", :with => user_id)
  fill_in("user_password", :with => "Pas$w0rd")
  click_button("Log in")
end

Given /^I have no users$/ do
  User.delete_all
end

Then /^I should be able to log in with "([^"]*)" and "([^"]*)"$/ do |user_id, password|
  visit path_to("the logout page")
  visit path_to("the login page")
  fill_in("user_user_id", :with => user_id)
  fill_in("user_password", :with => password)
  click_button("Log in")
  page.should have_content('Logged in successfully.')
  current_path.should == path_to('the home page')
end

When /^I attempt to login with "([^"]*)" and "([^"]*)"$/ do |user_id, password|
  visit path_to("the login page")
  fill_in("user_user_id", :with => user_id)
  fill_in("user_password", :with => password)
  click_button("Log in")
end

Then /^the failed attempt count for "([^"]*)" should be "([^"]*)"$/ do |user_id, count|
  user = User.where(:user_id => user_id).first
  user.failed_attempts.should == count.to_i
end

And /^I request a reset for "([^"]*)"$/ do |user_id|
  visit path_to("the home page")
  click_link "Forgot your password?"
  fill_in "Staff/Student ID", :with => user_id
  click_button "Send me reset password instructions"
end

And /^"([^"]*)" has supervisor "([^"]*)"$/ do |user_id, supervisor_user_id|
  user = User.find_by_user_id(user_id)
  supervisor = User.find_by_user_id(supervisor_user_id)
  user.add_supervisor(supervisor)
end

