Feature: Identify user by windows
  In order to use the system
  As a user
  I want to be identified by windows login

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have researchers
      | user_id       | email                  | first_name | last_name |
      | windowsuserid | seanl@intersect.org.au | Sean       | Lin       |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

  Scenario: Login with windows id which is existed in system
    Given The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=windowsuserid"
    Then I should be on the create experiment page
    And I should see "Welcome Sean Lin."
    And I should see field "Instrument" with value "Nikon Ti inverted epifluorescent microscope"

  Scenario: Login with windows id which is not existed in system
    Given The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=windowsuseridnotinthesystem"
    Then I should be on the request account page
    And I should see "You have not registered a user account with the Microbial Imaging facility. Please fill in the following details and register an account now. You will not be allowed access until your account has been approved by the administrator. "
    And I should see "windowsuseridnotinthesystem" in "Staff/Student ID" field

  Scenario: Login with windows id which is existed in system, but not in the lab
    Given The request ip address is "172.16.4.80"
    And I visit "/experiments/new?login_id=windowsuserid"
    And I should be on the login page
    Then I should see "Failed to Login"

  Scenario: Signed-in user who is not in lab cannot create new experiment by hardcoding URL
    Given The request ip address is "172.16.4.80"
    And I am logged in as "windowsuserid"
    And I visit "/experiments/new"
    And I should be on the home page
    Then I should see "You are not authorized to access this page."

  Scenario: Signed-in user who is not in lab cannot see "New Experiment" link
    Given The request ip address is "172.16.4.80"
    And I am logged in as "windowsuserid"
    Then I should not see link "New Experiment"

  Scenario: Login with an unapproved account
    Given I have access requests
      | user_id     | email                 | first_name | last_name |
      | userid4ryan | ryan@intersect.org.au | Ryan       | Braganza  |
    And The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=userid4ryan"
    And I should be on the inactive page
    Then I should see "userid4ryan could not be logged in."
    And I should see "Your account is not active at the moment"

  Scenario: Login with an deactivated account
    Given I have researchers
      | user_id     | email                 | first_name | last_name |
      | userid4ryan | ryan@intersect.org.au | Ryan       | Braganza  |
    And "userid4ryan" is deactivated
    And  The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=userid4ryan"
    And I should be on the inactive page
    Then I should see "userid4ryan could not be logged in."
    And I should see "Your account is not active at the moment"
