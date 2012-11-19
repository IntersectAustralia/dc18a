Feature: Manage supervisors
  As an administrator
  I want to have a full control over users and supervisors
  I do not allow other users(researchers and supervisors) to change supervisor list once registered
  I do not allow changing role from supervisor or administrator to researcher
  I do not allow removing supervisor from user's supervisor list when the user has projects which is supervised by that supervisor

  Background:
    Given I have no users
    And I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                     | first_name | last_name |
      | userid4seanl              | seanl@intersect.org.au    | Sean       | Lin       |
    And I have supervisors
      | user_id                   | email                     | first_name | last_name        |
      | userid4diego              | diego@intersect.org.au    | Diego      | Alonso de Marcos |
    And I have researchers
      | user_id                   | email                     | first_name | last_name |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo   |
    And "userid4diego" has supervisor "userid4seanl"
    And "userid4raul" has supervisor "userid4seanl"
    And "userid4raul" has supervisor "userid4diego"
    And "userid4raul" has projects
      | name | supervisor   |
      | p1   | userid4diego |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

  Scenario: Administrator can edit user details
    Given I am logged in as "userid4seanl"
    When I am on the list users page
    # In test environment, there are only 2 rows per page, userid4seanl will be displayed on Page 2
    # we just ignore it here
    Then I should see "users" table with
      |Staff/Student ID | Given Name | Surname          | Email                  | Role          | Status |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au | Supervisor    | Active |
      |userid4raul      | Raul       | Carrizo          | raul@intersect.org.au  | Researcher    | Active |
    When I follow "Edit Details" for "userid4raul"
    Then I should be on the edit user details page for "userid4raul"
    When I fill in "Email" with "raul.carrizo@gmail.com"
    And I press "Update"
    Then I should be on the list users page
    And I should see "User details has been updated"

  Scenario: Administrator can edit supervisors list
    Given I am logged in as "userid4seanl"
    When I am on the list users page
    Then I should see "users" table with
      |Staff/Student ID | Given Name | Surname          | Email                  | Role          | Status |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au | Supervisor    | Active |
      |userid4raul      | Raul       | Carrizo          | raul@intersect.org.au  | Researcher    | Active |
    When I follow "Edit Details" for "userid4raul"
    Then I should be on the edit user details page for "userid4raul"
    And "Sean Lin" should be selected for "Supervisors"
    And "Diego Alonso de Marcos" should be selected for "Supervisors"
    When I unselect "Sean Lin" from "Supervisors"
    And I press "Update"
    Then I should be on the list users page
    And I should see "User details has been updated"
    When I follow "Edit Details" for "userid4raul"
    Then I should be on the edit user details page for "userid4raul"
    And "Sean Lin" should not be selected for "Supervisors"
    And "Diego Alonso de Marcos" should be selected for "Supervisors"

  Scenario: Supervisor cannot edit supervisors list
    Given I am logged in as "userid4diego"
    When I am on the edit my details page
    Then I should not see "Supervisors" field

  Scenario: Supervisor cannot edit other user's detail
    Given I am logged in as "userid4diego"
    When I am on the edit user details page for "userid4raul"
    Then I should see "You are not authorized to access this page"

  Scenario: Researcher cannot edit supervisors list
    Given I am logged in as "userid4raul"
    When I am on the edit my details page
    Then I should not see "Supervisors" field

  Scenario: Researcher cannot edit other user's detail
    Given I am logged in as "userid4raul"
    When I am on the edit user details page for "userid4diego"
    Then I should see "You are not authorized to access this page"

  Scenario: Supervisor or Administrator role can not be changed to researcher role
    Given I am logged in as "userid4seanl"
    When I am on the list users page
    Then I should see "users" table with
      |Staff/Student ID | Given Name | Surname          | Email                  | Role          | Status |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au | Supervisor    | Active |
      |userid4raul      | Raul       | Carrizo          | raul@intersect.org.au  | Researcher    | Active |
    When I follow "Edit role" for "userid4diego"
    Then I should be on the edit role page for "userid4diego"
    And I should not see "Researcher" option for "Role"
    And "Supervisor" should be selected for "Role"
    When I am on the list users page
    And I follow "Edit role" for "userid4raul"
    Then I should be on the edit role page for "userid4raul"
    And I should see "Researcher" option for "Role"
    And "Researcher" should be selected for "Role"

  Scenario: Administrator cannot remove a supervisor from supervisor list when the user has projects which is supervised by that supervisor
    Given I am logged in as "userid4seanl"
    When I am on the list users page
    Then I should see "users" table with
      |Staff/Student ID | Given Name | Surname          | Email                  | Role          | Status |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au | Supervisor    | Active |
      |userid4raul      | Raul       | Carrizo          | raul@intersect.org.au  | Researcher    | Active |
    When I follow "Edit Details" for "userid4raul"
    Then I should be on the edit user details page for "userid4raul"
    And "Sean Lin" should be selected for "Supervisors"
    And "Diego Alonso de Marcos" should be selected for "Supervisors"
    When I unselect "Diego Alonso de Marcos" from "Supervisors"
    And I press "Update"
    And I should see "User details was not updated"
    And I should see "Diego Alonso de Marcos cannot be removed from supervisor list"
    And "Sean Lin" should be selected for "Supervisors"
    And "Diego Alonso de Marcos" should not be selected for "Supervisors"
