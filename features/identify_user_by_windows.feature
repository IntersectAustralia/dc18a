Feature: Identify user by windows
  In order to use the system
  As a user
  I want to be identified by windows login

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have researchers
      | user_id                   | email                     | first_name | last_name |
      | windowsuserid             | seanl@intersect.org.au    | Sean       | Lin       |

  Scenario: Login with windows id which is existed in system
    Given The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=windowsuserid"
    Then I should be on the cerate experiment page
    And I should see "Welcome Sean Lin."
    And I should see "Instrument: Nikon Ti inverted epifluorescent microscope"

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
