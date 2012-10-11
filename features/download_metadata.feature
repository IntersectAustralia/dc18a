Feature: Download metadata
  As a researcher
  I would like to download a file that contains my experiment metadata so that I can keep track of my experiment details

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have supervisors
      | user_id           | email                       | first_name | last_name |
      | userid4supervisor | supervisor@intersect.org.au | Supervisor | User      |
    And I have researchers
      | user_id     | email                 | first_name | last_name |
      | userid4raul | raul@intersect.org.au | Raul       | Carrizo   |
    And "userid4raul" has supervisor "userid4supervisor"
    And "userid4raul" has projects
      | name | supervisor        |
      | p1   | userid4supervisor |
    And "userid4raul" has experiments
      | name | project | instrument |
      | e1   | p1      | Nikon T1   |

  Scenario: experiments should have download link
    Given I am logged in as "userid4raul"
    And I am on the home page
    Then I should see "projects" table with
      | Project Name | Owner        |
      | p1           | Raul Carrizo |
    When I follow "View Details" for project "p1"
    Then I should see "experiments" table with
      | Experiment Name |
      | e1              |
    And I should see link "Download Metadata"
    Then I follow "Save and Download Metadata" for experiment "e1"
    Then I should get a download "YYYYMMDD_P<p_id>_E<e_id>_<instrument>_<last_name>_<first_name>.zip" for "e1"

  @javascript
  Scenario: Logging in with windows id shows close button for experiments
    Given The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=userid4raul"
    And I have experiments
      | project | expt_name | owner       | lab_book_no |
      | p1      | e1        | userid4raul | 123         |
    And I am on the home page
    When I follow "View Details" for project "p1"
    And I follow "View Details"
    And I follow "Download Folder"
    And I should see button "Close Window"

  Scenario: Logging in normally shows close button for experiments
    Given I am logged in as "userid4raul"
    And I have experiments
      | project | expt_name | owner       | lab_book_no |
      | p1      | e1        | userid4raul | 123         |
    And I am on the home page
    When I follow "View Details" for project "p1"
    And I follow "View Details"
    And I follow "Download Folder"
    And I should not see link "Close Window"
