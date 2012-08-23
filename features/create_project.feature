Feature: Create project
  In order to use microscope
  As a researcher
  I would like to create a project so that I can enter my metadata

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have supervisors
      | user_id                   | email                           | first_name | last_name |
      | userid4seanlin            | seanl@intersect.org.au    | Sean       | Lin       |
    And I have researchers
      | user_id                   | email                     | first_name | last_name        |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo          |
    And "userid4raul" has supervisor "userid4seanlin"
    And I am logged in as "userid4raul"

  @javascript
  Scenario: Create a project
    Given I am on the home page
    When I follow "Create Project"
    And I fill in "Project Name" with "Test Project"
    And I fill in "Project Description" with "This is a test project"
    And I select "Yes" from "Funded by Agency"
    And I select "National Health and Medical Research Council" from "If yes please specify"
    And I select "Sean Lin" from "Supervisor"
    And I press "Create Project"
    Then I should be on the home page
    And I should see "Project created."
    And I should see "projects" table with
      | Project Name     |
      | Test Project     |

  Scenario: Mandatory fields should be validated
    Given I am on the home page
    When I follow "Create Project"
    And I press "Create Project"
    Then I should see "Please fill in all mandatory fields."
    And the "Project Name" field should have the error "can't be blank"
    And the "Project Description" field should have no errors
    And the "Supervisor" field should have the error "can't be blank"

  @javascript
  Scenario: Funding agency selector should be validated
    Given I am on the home page
    When I follow "Create Project"
    And I fill in "Project Name" with "Test Project"
    And I fill in "Project Description" with "This is a test project"
    And I select "Yes" from "Funded by Agency"
    And I select "Sean Lin" from "Supervisor"
    And I press "Create Project"
    Then I should see "Please fill in all mandatory fields."
    And the "If yes please specify" field should have the error "can't be blank"

  @javascript
  Scenario: Other funding agency should be validated
    Given I am on the home page
    When I follow "Create Project"
    When I fill in "Project Name" with "Test Project"
    And I fill in "Project Description" with "This is a test project"
    And I select "Yes" from "Funded by Agency"
    And I select "Other" from "If yes please specify"
    And I select "Sean Lin" from "Supervisor"
    And I press "Create Project"
    Then I should see "Please fill in all mandatory fields."
    And the "If Other please specify" field should have the error "can't be blank"

  Scenario: Cancel
    Given I am on the home page
    When I follow "Create Project"
    And I follow "Cancel"
    Then I should be on the home page
    And I should see "Project was not created."

  Scenario: Duplicate project name should be allowed
    Given "userid4raul" has projects
    | name |
    | test |
    | test |
    When I am on the home page
    Then I should see "projects" table with
      | Project Name     |
      | test             |
      | test             |

  @javascript
  Scenario: Change "Funded by Agency" to "No" should clear both "If yes please specify" and "If Other please specify"
    Given I am on the home page
    When I follow "Create Project"
    And I fill in "Project Name" with "Test Project"
    And I fill in "Project Description" with "This is a test project"
    And I select "Yes" from "Funded by Agency"
    And I select "Other" from "If yes please specify"
    And I fill in "If Other please specify" with "Other Agency"
    And I select "Sean Lin" from "Supervisor"
    And I select "No" from "Funded by Agency"
    And I press "Create Project"
    Then I should be on the home page
    And I should see "Project created."
    And "agency" of "Test Project" should not be set
    And "other_agency" of "Test Project" should not be set
