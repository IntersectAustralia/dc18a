Feature: Create experiment
  In order to do an experiment
  As a researcher
  I would like to create an experiment so that I can record my experiment data

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                           | first_name | last_name |
      | userid4admin              | admin@intersect.org.au          | Administrator       | Super       |
    And I have supervisors
      | user_id                   | email                           | first_name | last_name |
      | userid4seanlin            | seanl@intersect.org.au       | Sean       | Lin       |
      | userid4veronica           | veronica@intersect.org.au    | Veronica   | Luke       |
    And I have researchers
      | user_id                   | email                     | first_name | last_name        |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo          |
    And "userid4raul" has supervisor "userid4seanlin"
    And "userid4raul" has supervisor "userid4veronica"
    And "userid4admin" has supervisor "userid4admin"
    And I have projects
      | owner       | project_name | description | funded_by_agency | funded_by | supervisor     |
      | userid4raul | Project A    | Some desc A | false            |           | userid4seanlin |
      | userid4raul | Project B    | Some desc B | true             | NHMRC     | userid4veronica|
    And I am logged in as "userid4raul"

  @javascript
  Scenario: Experiment Validation
    Given I am on the home page
    When I follow "New Experiment"
    And I select "Project A" from "project_select"
    And I press "Create Experiment"
    Then I should see "Please fill in all mandatory fields"

  @javascript
  Scenario: Create an experiment
    Given I am on the home page
    When I follow "New Experiment"
    And I select "Project A" from "project_select"
    Then I should see "Project ID:"
    Then I should see "Description: Some desc A"
    Then I should see "Date Created"
    Then I should see "Funded By:"
    Then I should see "Supervisor: Sean Lin"
    And I fill in "Experiment Name" with "Experiment 1"
    And I fill in "Lab Book No." with "111"
    And I fill in "Page No." with "22"
    And I fill in "Cell Type or Tissue" with "Tissue A"
    And I select "Fixed" from "Experiment Type"
    And I check "Slides"
    And I check "Immunofluorescence"
    And I press "Create Experiment"
    Then I should be on the home page
    And I should see "Experiment created"