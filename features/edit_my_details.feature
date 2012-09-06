Feature: Edit my details
  In order to keep my details up to date
  As a user
  I want to edit my details
  
  Background:
    Given I have a user "userid4seanlin"
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
