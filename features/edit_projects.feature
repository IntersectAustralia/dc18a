Feature: Edit projects
  As an user
  I would like to edit a project so that I can fix my mistakes

  Background:
    Given I have no users
    And I have no projects
    Given I have the usual roles and permissions
    And I have researchers
      | user_id                   | email                           | first_name | last_name |
      | userid4seanl              | seanl@intersect.org.au          | Sean       | Lin       |
    And "userid4seanl" has projects
      | name |
      | p1           |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |
    And I am logged in as "userid4seanl"

  Scenario: Edit project from list view
    Given I am on the home page
    Then I should see "projects" table with
      | Project Name    |
      | p1              |
    And I should see link "Edit Project"
    When I follow "Edit Project"
    And I fill in "Project Name" with "Test Project"
    And I press "Update Project"
    Then I should see "Project updated."
    And I should be on the view project page for "Test Project"

  Scenario: Edit project from details view
    Given I am on the home page
    Then I should see "projects" table with
      | Project Name    |
      | p1              |
    When I follow "View Details"
    Then I should be on the view project page for "p1"
    When I follow "Edit Project"
    Then the "Project Name" field should contain "p1"
    And I fill in "Project Name" with "Test Project"
    And I press "Update Project"
    Then I should see "Project updated."
    And I should be on the view project page for "Test Project"

  Scenario: Cancel
    Given I am on the home page
    When I follow "Edit Project"
    And I follow "Cancel"
    Then I should be on the home page
    And I should see "Project was not updated."
