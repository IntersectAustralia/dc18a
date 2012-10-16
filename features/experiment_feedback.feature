Feature: Experiment Feedback
  As a researcher
  I want to be prompted to enter data about the experiment
  So that I there is a record of whether the experiment is successful

  Background:
    Given I have the usual roles and permissions
    And I have administrators
      | user_id       | email                   | first_name    | last_name |
      | userid4admin1 | admin1@intersect.org.au | Administrator | Super1    |
      | userid4admin2 | admin2@intersect.org.au | Administrator | Super2    |
    And I have supervisors
      | user_id         | email                     | first_name | last_name |
      | userid4veronica | veronica@intersect.org.au | Veronica   | Luke      |
    And I have researchers
      | user_id     | email                 | first_name | last_name |
      | userid4raul | raul@intersect.org.au | Raul       | Carrizo   |
    And "userid4raul" has supervisor "userid4veronica"
    And I have projects
      | owner       | project_name | description | funded_by_agency | funded_by | supervisor      |
      | userid4raul | Project A    | Some desc A | false            |           | userid4veronica |
    And I have experiments
      | project   | expt_name | owner       | lab_book_no |
      | Project A | e1        | userid4raul | 123         |
    And I am logged in as "userid4raul"


  Scenario: Collect feedback on Experiment
    Given I am on the feedback page
    When I check "Experiment failed"
    And I check "Instrument failed"
    And I fill in "Instrument failed reason" with "Technical Difficulties"
    And I fill in "Other comments" with "Please repeat experiment"
    And I press "Submit"
    Then I should see "Experiment feedback is saved"
    And I should see field "Experiment Failed" with value "Yes"
    And I should see field "Instrument Failed" with value "Yes"
    And I should see field "Instrument Failed Reason" with value "Technical Difficulties"
    And I should see field "Other Comments" with value "Please repeat experiment"
    And "admin1@intersect.org.au" should receive an email with subject "DC18A - Instrument Failure for Experiment 'e1'"
    And "admin2@intersect.org.au" should receive an email with subject "DC18A - Instrument Failure for Experiment 'e1'"
    When I open the email
    Then I should see "An instrument failure has occurred:" in the email body
    And I should see "Instrument with failure:" in the email body
    And I should see "Failure Reason: Technical Difficulties" in the email body
    And I should see "From Experiment: e1" in the email body
    And I should see "Reported by user: Raul Carrizo" in the email body

  Scenario: Edit feedback on Experiment
    Given I am on the feedback page
    When I check "Experiment failed"
    And I check "Instrument failed"
    And I fill in "Instrument failed reason" with "Technical Difficulties"
    And I fill in "Other comments" with "Please repeat experiment"
    And I press "Submit"
    Then I should see "Experiment feedback is saved"
    Given I am on the feedback page
    And I press "Submit"
    Then I should see "Experiment feedback is saved"
    And I should see field "Experiment Failed" with value "Yes"
    And I should see field "Instrument Failed" with value "Yes"
    And I should see field "Instrument Failed Reason" with value "Technical Difficulties"
    And I should see field "Other Comments" with value "Please repeat experiment"
