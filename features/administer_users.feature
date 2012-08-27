Feature: Administer users
  In order to allow users to access the system
  As an administrator
  I want to administer users

  Background:
    Given I have users
      | user_id                   | email                     | first_name | last_name |
      | userid4seanlin            | seanl@intersect.org.au    | Sean       | Lin       |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo   |
    And I have the usual roles and permissions
    And I am logged in as "userid4seanlin"
    And "userid4seanlin" has role "Administrator"

  Scenario: View a list of users
    Given "userid4raul" is deactivated
    When I am on the list users page
    Then I should see "users" table with
      |Staff/Student ID | Given Name | Surname | Email                     | Role          | Status       |
      |userid4raul      | Raul       | Carrizo   | raul@intersect.org.au     |               | Deactivated  |
      |userid4seanlin   | Sean       | Lin       | seanl@intersect.org.au    | Administrator | Active       |
    When I follow "Staff/Student ID"
    Then I should see "users" table with
      |Staff/Student ID | Given Name | Surname | Email                     | Role          | Status       |
      |userid4seanlin   | Sean       | Lin       | seanl@intersect.org.au    | Administrator | Active       |
      |userid4raul      | Raul       | Carrizo   | raul@intersect.org.au     |               | Deactivated  |

  Scenario: View user details
    Given "userid4raul" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "userid4raul"
    Then I should see field "Staff/Student ID" with value "userid4raul"
    And I should see field "Email" with value "raul@intersect.org.au"
    And I should see field "Given Name" with value "Raul"
    And I should see field "Surname" with value "Carrizo"
    And I should see field "Role" with value "Researcher"
    And I should see field "Status" with value "Active"
    And I should see "Last Logged In"
    And I should see "Date Account Requested"
    And I should see field "Supervisors" with value "N/A"
    And I should see "Department/Institute"

  Scenario: Go back from user details
    Given I am on the list users page
    When I follow "View Details" for "userid4seanlin"
    And I follow "Back"
    Then I should be on the list users page

  Scenario: Edit role
    Given "userid4raul" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "userid4raul"
    And I follow "Edit role"
    And I select "Administrator" from "Role"
    And I press "Save"
    Then I should be on the user details page for userid4raul
    And I should see "The role for userid4raul was successfully updated."
    And I should see field "Role" with value "Administrator"

  Scenario: Edit role from list page
    Given "userid4raul" has role "Researcher"
    And I am on the list users page
    When I follow "Edit role" for "userid4raul"
    And I select "Administrator" from "Role"
    And I press "Save"
    Then I should be on the user details page for userid4raul
    And I should see "The role for userid4raul was successfully updated."
    And I should see field "Role" with value "Administrator"

  Scenario: Cancel out of editing roles
    Given "userid4raul" has role "Researcher"
    And I am on the list users page
    When I follow "View Details" for "userid4raul"
    And I follow "Edit role"
    And I select "Administrator" from "Role"
    And I follow "Back"
    Then I should be on the user details page for userid4raul
    And I should see field "Role" with value "Researcher"

  Scenario: Role should be mandatory when editing Role
    And I am on the list users page
    When I follow "View Details" for "userid4raul"
    And I follow "Edit role"
    And I select "" from "Role"
    And I press "Save"
    Then I should see "Please select a role for the user."

  Scenario: Deactivate active user
    Given I am on the list users page
    When I follow "View Details" for "userid4raul"
    And I follow "Deactivate"
    Then I should see "The user has been deactivated"
    And I should see "Activate"

  Scenario: Activate deactivated user
    Given "userid4raul" is deactivated
    And I am on the list users page
    When I follow "View Details" for "userid4raul"
    And I follow "Activate"
    Then I should see "The user has been activated"
    And I should see "Deactivate"

  Scenario: Can't deactivate the last administrator account
    Given I am on the list users page
    When I follow "View Details" for "userid4seanlin"
    And I follow "Deactivate"
    Then I should see "You cannot deactivate this account as it is the only account with Administrator privileges."
    And I should see field "Status" with value "Active"

  Scenario: Editing own role has alert
    Given I am on the list users page
    When I follow "View Details" for "userid4seanlin"
    And I follow "Edit role"
    Then I should see "You are changing the role of the user you are logged in as."

  Scenario: Should not be able to edit role of rejected user by direct URL entry
    Given I have a rejected as spam user "userid4spammer"
    And I go to the edit role page for userid4spammer
    Then I should be on the list users page
    And I should see "Role can not be set. This user has previously been rejected as a spammer."

