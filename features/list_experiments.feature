Feature: List experiments
  As a researcher
  I would like to list all my experiments for a project
  So that I can see what experiments belong to a project

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                           | first_name | last_name |
      | userid4admin              | admin@intersect.org.au          | Administrator       | Super       |
    And I have supervisors
      | user_id                   | email                           | first_name | last_name |
      | userid4seanl              | seanl@intersect.org.au       | Sean       | Lin       |
      | userid4veronica           | veronica@intersect.org.au    | Veronica   | Luke       |
    And I have researchers
      | user_id                   | email                     | first_name | last_name        |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo          |
    And "userid4raul" has supervisor "userid4seanl"
    And "userid4raul" has supervisor "userid4veronica"
    And "userid4admin" has supervisor "userid4admin"
    And I have projects
      | owner       | project_name | description | funded_by_agency | funded_by | supervisor     |
      | userid4raul | Project A    | Some desc A | false            |           | userid4seanl   |
      | userid4raul | Project B    | Some desc B | true             | NHMRC     | userid4veronica|
    And I have experiments
      | project   | expt_name  | owner        | lab_book_no |
      | Project A | e1         | userid4raul  | 123         |
      | Project A | e2         | userid4seanl | 456         |
      | Project B | e3         | userid4raul  | 789         |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

  Scenario: List experiments on View Project page
    Given I am logged in as "userid4raul"
    And I am on the view project page for "Project A"
    Then I should see "experiments" table with
      | ID | Experiment Name | Owner        | Lab Book No. |
      | 1  | e1              | Raul Carrizo | 123          |
      | 2  | e2              | Sean Lin     | 456          |
    And I am on the view project page for "Project B"
    Then I should see "experiments" table with
      | ID | Experiment Name | Owner        | Lab Book No. |
      | 1  | e3              | Raul Carrizo | 789          |

