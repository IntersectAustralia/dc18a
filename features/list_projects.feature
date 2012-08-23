Feature: List projects
  As a researcher
  I would like to list my projects

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                           | first_name | last_name |
      | userid4seanlin            | seanl@intersect.org.au          | Sean       | Lin       |
    And I have supervisors
      | user_id                   | email                           | first_name | last_name |
      | userid4supervisor1        | supervisor1@intersect.org.au    | Supervisor | 1         |
      | userid4supervisor2        | supervisor2@intersect.org.au    | Supervisor | 2         |
    And I have researchers
      | user_id                   | email                     | first_name | last_name        |
      | userid4raul               | raul@intersect.org.au     | Raul       | Carrizo          |
      | userid4fred               | fred@intersect.org.au     | Fred       | Fleggss          |
    And "userid4raul" has projects
      | name |
      | p1   |
      | p2   |
      | p3   |
    And "userid4fred" has projects
      | name |
      | p4   |
      | p5   |

  Scenario: List projects should be paginated
    Given I am logged in as "userid4raul"
    And I am on the home page
    Then I should see "projects" table with
      | Project Name    | Owner         |
      | p1              | Raul Carrizo  |
      | p2              | Raul Carrizo  |
    When I follow "Next"
    Then I should see "projects" table with
      | Project Name    | Owner         |
      | p3              | Raul Carrizo  |
    When I follow "Previous"
    Then I should see "projects" table with
      | Project Name    | Owner         |
      | p1              | Raul Carrizo  |
      | p2              | Raul Carrizo  |

  Scenario: Administrator should list all projects
    Given I am logged in as "userid4seanlin"
    And I am on the home page
    Then I should see "projects" table with
      | Project Name    | Owner         |
      | p1              | Raul Carrizo  |
      | p2              | Raul Carrizo  |
    When I follow "Next"
    Then I should see "projects" table with
      | Project Name    | Owner         |
      | p3              | Raul Carrizo  |
      | p4              | Fred Fleggss  |
    When I follow "Next"
    Then I should see "projects" table with
      | Project Name    | Owner         |
      | p5              | Fred Fleggss  |
