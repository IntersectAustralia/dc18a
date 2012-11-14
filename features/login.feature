Feature: Logging In
  In order to use the system
  As a user
  I want to login

  Background:
    Given I have roles
      | name            |
      | Administrator   |
      | Researcher      |
    And I have permissions
      | entity | action          | roles          |
      | User   | read            | Administrator  |
      | User   | admin           | Administrator  |
      | User   | access_requests | Administrator  |
    And I have a user "userid4seanlin"
    And "userid4seanlin" has role "Administrator"
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

  Scenario: Successful login
    Given I am on the login page
    When I fill in "Staff/Student ID" with "userid4seanlin"
    And I fill in "Password" with "Pass.123"
    And I press "Log in"
    Then I should see "Logged in successfully."
    And I should be on the home page

  Scenario: Successful login from home page
    Given I am on the home page
    When I fill in "Staff/Student ID" with "userid4seanlin"
    And I fill in "Password" with "Pass.123"
    And I press "Log in"
    Then I should see "Logged in successfully."
    And I should be on the home page

  Scenario: Should be redirected to the login page when trying to access a secure page
    Given I am on the list users page
    Then I should see "You need to log in before continuing."
    And I should be on the login page

  Scenario: Should be redirected to requested page after logging in following a redirect from a secure page
    Given I am on the list users page
    When I fill in "Staff/Student ID" with "userid4seanlin"
    And I fill in "Password" with "Pass.123"
    And I press "Log in"
    Then I should see "Logged in successfully."
    And I should be on the list users page

  Scenario Outline: Failed logins due to missing/invalid details
    Given I am on the login page
    When I fill in "Staff/Student ID" with "<user_id>"
    And I fill in "Password" with "<password>"
    And I press "Log in"
    Then I should see "Invalid staff/student id or password."
    And I should be on the login page
  Examples:
    | user_id                   | password         | explanation                |
    |                           |                  | nothing                    |
    |                           | Pass.123         | missing Staff/Student ID   |
    | userid4seanlin            |                  | missing password           |
    | invaliduserid             | Pass.123         | invalid Staff/Student ID   |
    | userid4seanlin            | wrong            | wrong password             |

  Scenario Outline: Logging in as a deactivated / pending approval / rejected as spam with correct password
    Given I have a deactivated user "userid4deact"
    And I have a rejected as spam user "userid4spammer"
    And I have a pending approval user "userid4pending"
    And I am on the login page
    When I fill in "Staff/Student ID" with "<Staff/Student ID>"
    And I fill in "Password" with "<Password>"
    And I press "Log in"
    Then I should see "Your account is not active."
  Examples:
    | Staff/Student ID                    | Password |
    | userid4deact                        | Pass.123 |
    | userid4spammer                      | Pass.123 |
    | userid4pending                      | Pass.123 |

  Scenario Outline: Logging in as a deactivated / pending approval / rejected as spam / with incorrect password should not reveal if user exists
    Given I have a deactivated user "userid4deact"
    And I have a rejected as spam user "userid4spammer"
    And I have a pending approval user "userid4pending"
    And I am on the login page
    When I fill in "Staff/Student ID" with "<Staff/Student ID>"
    And I fill in "Password" with "<Password>"
    And I press "Log in"
    Then I should see "Invalid staff/student id or password."
    And I should not see "Your account is not active."
  Examples:
    | Staff/Student ID                    | Password |
    | userid4deact                        | pa       |
    | userid4spammer                      | pa       |
    | userid4pending                      | pa       |
