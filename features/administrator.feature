Feature: Administrator features
  In order to use microscope
  As a administrator
  I would like to create a project so that I can enter my metadata

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                     | first_name | last_name |
      | userid4seanlin            | seanl@intersect.org.au    | Sean       | Lin       |
    And "userid4seanlin" has supervisor "userid4seanlin"
    And I am logged in as "userid4seanlin"

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
