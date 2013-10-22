Feature: Edit my details
  In order to keep my details up to date
  As a user
  I want to edit my details
  
  Background:
    Given I have no users
    Given I have the usual roles and permissions
    Given I have a user "userid4seanlin"
    And I have administrators
      | user_id      | email                  | first_name | last_name |
      | userid4seanl | seanl@intersect.org.au | Sean       | Lin       |
    And I have supervisors
      | user_id            | email                        | first_name | last_name |
      | userid4supervisor1 | supervisor1@intersect.org.au | Supervisor | 1         |
      | userid4supervisor2 | supervisor2@intersect.org.au | Supervisor | 2         |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |
    And I am logged in as "userid4seanlin"

  Scenario: Edit my information
    Given I am on the home page
    When I follow "Edit My Details"
    And I fill in "Surname" with "Fred"
    And I fill in "Given Name" with "Bloggs"
    And I fill in "Email" with "sean@email.com"
    And I press "Update"
    Then I should see "Your account details have been successfully updated."
    And I should be on the home page
    And I follow "Edit My Details"
    And the "Surname" field should contain "Fred"
    And the "Given Name" field should contain "Bloggs"

  Scenario: Validation error
    Given I am on the home page
    When I follow "Edit My Details"
    And I fill in "Surname" with ""
    And I fill in "Given Name" with "Bloggs"
    And I press "Update"
    Then the "Surname" field should have the error "can't be blank"

  Scenario: Cancel editing my information
    Given I am on the home page
    When I follow "Edit My Details"
    And I follow "Cancel"
    Then I should be on the home page

  Scenario: Deactivated supervisor shouldn't be displayed in the supervisor list
    Given I have supervisors
      | user_id     | email                 |
      | userid4fred | fred@intersect.org.au |
    And "userid4fred" is deactivated
    And I am on the home page
    When I follow "Logout"
    And I am logged in as "userid4seanl"
    And I follow "Edit My Details"
    Then I should see "Supervisor 1" option for "Supervisors"
    And I should see "Supervisor 2" option for "Supervisors"
    And I should not see "userid4fred" option for "Supervisors"
