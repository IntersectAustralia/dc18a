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
    Given I visit "/experiments/new?login_id=windowsuserid&ip=172.16.4.78"
    Then I should be on the cerate experiment page
    And I should see "Welcome Sean Lin."

  Scenario: Login with windows id which is not existed in system
    Given I visit "/experiments/new?login_id=windowsuseridnotinthesystem&ip=172.16.4.78"
    Then I should be on the request account page
    And I should see "You have not registered a user account Microbial Imaging facility. Please fill in the following details and register an account now. You will not be allowed to gain access until your account has been approved by the administrator. "
    And I should see "windowsuseridnotinthesystem" in "Staff/Student ID" field
