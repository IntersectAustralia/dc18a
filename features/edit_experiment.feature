Feature: Edit experiment
  As a researcher I would like to edit an experiment so that I can edit my experiment metadata

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                     | first_name | last_name |
      | userid4seanl              | seanl@intersect.org.au    | Sean       | Lin       |
    And I have supervisors
      | user_id         | email                           | first_name | last_name |
      | userid4diego    | supervisor1@intersect.org.au    | Supervisor | 1         |
    And I have researchers
      | user_id     | email                 | first_name | last_name |
      | userid4raul | raul@intersect.org.au | Raul       | Carrizo   |
      | userid4luar | luar@intersect.org.au | Luar       | Carrizo   |
    And "userid4raul" has supervisor "userid4diego"
    And I have projects
      | owner       | project_name | description | funded_by_agency | funded_by | supervisor      |
      | userid4raul | Project A    | Some desc A | false            |           | userid4diego    |
      | userid4luar | Project B    | Some desc B | false            |           | userid4diego    |
    And I have experiments
      | owner       | project   | expt_name    | lab_book_no | page_no |
      | userid4raul | Project A | Experiment A | 65          | 66      |
      | userid4luar | Project B | Experiment B | 67          | 68      |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

  Scenario: Edit experiment in the lab, out of session
    Given I am logged in as "userid4raul"
    And The request ip address is "172.16.4.78"
    And The experiment "Experiment A" is finished
    And I am on the view experiment page for "Experiment A"
    Then I should not see link "Edit Experiment"
    When I am on the edit experiment page for "Experiment A"
    Then I should see "You are not authorized to access this page"

  Scenario: Edit experiment not in the lab
    Given I am logged in as "userid4raul"
    And The request ip address is "172.16.4.80"
    And I am on the view experiment page for "Experiment A"
    Then I should not see link "Edit Experiment"
    When I am on the edit experiment page for "Experiment A"
    Then I should see "You are not authorized to access this page"

  Scenario: Cancel edit experiment
    Given I am logged in as "userid4raul"
    And The request ip address is "172.16.4.78"
    And I am on the view experiment page for "Experiment A"
    Then I should see link "Edit Experiment"
    When I follow "Edit Experiment"
    And I follow "Cancel"
    Then I should be on the view experiment page for "Experiment A"
    And I should see "Experiment was not updated"

  @javascript
  Scenario: Edit experiment in the lab, within session
    Given I am logged in as "userid4raul"
    And The request ip address is "172.16.4.78"
    And I am on the view experiment page for "Experiment A"
    Then I should see link "Edit Experiment"
    When I follow "Edit Experiment"
    And I fill in "Experiment Name" with "Experiment B"
    And I press "Update Experiment"
    Then I should be on the view experiment page for "Experiment B"
    And I should see "Experiment updated"

  @javascript
  Scenario: Edit other people's experiment in the lab, within session
    Given I am logged in as "userid4raul"
    And The request ip address is "172.16.4.78"
    And I am on the edit experiment page for "Experiment B"
    Then I should see "You are not authorized to access this page"

  @javascript
  Scenario: Supervisor edit researcher's experiment in the lab, within session
    Given I am logged in as "userid4diego"
    And The request ip address is "172.16.4.78"
    And I am on the edit experiment page for "Experiment A"
    Then I should see "You are not authorized to access this page"

  @javascript
  Scenario: Administrator edit researcher's experiment in the lab, within session
    Given I am logged in as "userid4seanl"
    And The request ip address is "172.16.4.78"
    And I am on the edit experiment page for "Experiment A"
    Then I should see "You are not authorized to access this page"
