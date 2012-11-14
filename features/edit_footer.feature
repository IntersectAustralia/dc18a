Feature: Edit footer text
  As an administrator I want to configure the text displayed on the register account page so that it's always up to date
  
  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                     | first_name | last_name |
      | userid4seanl              | seanl@intersect.org.au    | Sean       | Lin       |
    And I have supervisors
      | user_id                   | email                           | first_name | last_name |
      | userid4diego              | supervisor1@intersect.org.au    | Supervisor | 1         |
    And I have researchers
      | user_id                   | email                     | first_name | last_name |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo   |
    And "userid4raul" has supervisor "userid4diego"
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

  Scenario: Edit footer text
    Given I am logged in as "userid4seanl"
    And I am on the home page
    Then I should see link "Edit Footer Text"
    When I follow "Edit Footer Text"
    Then I should be on the edit footer text page
    And I fill in "Text" with "Footer text ABC"
    And I press "Update"
    Then I should see "Footer text updated"
    And I should be on the home page
    And I should see "Footer text ABC"

  Scenario: Supervisor can not edit footer text
    Given I am logged in as "userid4diego"
    And I am on the home page
    Then I should not see link "Edit Footer Text"
    When I am on the edit footer text page
    Then I should see "You are not authorized to access this page"

  Scenario: Researcher can not edit footer text
    Given I am logged in as "userid4raul"
    And I am on the home page
    Then I should not see link "Edit Footer Text"
    When I am on the edit footer text page
    Then I should see "You are not authorized to access this page"

  Scenario: Validate required text field
    Given I am logged in as "userid4seanl"
    And I am on the home page
    And I follow "Edit Footer Text"
    And I fill in "Text" with ""
    And I press "Update"
    Then the "Text" field should have the error "can't be blank"

  Scenario: Validate required text field
    Given I am logged in as "userid4seanl"
    And I am on the home page
    And I follow "Edit Footer Text"
    And I fill in "Text" with "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    And I press "Update"
    Then the "Text" field should have the error "is too long (maximum is 512 characters)"

  Scenario: Cancel
    Given I am logged in as "userid4seanl"
    And I am on the home page
    And I follow "Edit Footer Text"
    And I follow "Cancel"
    Then I should be on the home page
    And I should see "Footer text was not updated."

