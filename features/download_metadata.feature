Feature: Download metadata
  As a researcher
  I would like to download a file that contains my experiment metadata so that I can keep track of my experiment details

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id                   | email                     | first_name | last_name |
      | userid4seanl              | seanl@intersect.org.au    | Sean       | Lin       |
    And I have supervisors
      | user_id           | email                       | first_name | last_name |
      | userid4supervisor | supervisor@intersect.org.au | Supervisor | User      |
    And I have researchers
      | user_id     | email                 | first_name | last_name |
      | userid4raul | raul@intersect.org.au | Raul       | Carrizo   |
      | userid4luar | luar@intersect.org.au | Luar       | Carrizo   |
    And "userid4raul" has supervisor "userid4supervisor"
    And "userid4luar" has supervisor "userid4supervisor"
    And "userid4raul" has projects
      | name | supervisor        |
      | p1   | userid4supervisor |
    And "userid4raul" has experiments
      | name | project | instrument |
      | e1   | p1      | Nikon T1   |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |

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
  Scenario: Logging in lab shows close button for experiments
    Given The request ip address is "172.16.4.78"
    And I visit "/experiments/new?login_id=userid4raul"
    And I am on the home page
    When I follow "View Details" for project "p1"
    And I follow "View Details"
    And I should see "button will only be activated once the zip file has been downloaded"
    And I follow "Download Metadata"
    And I should see button "Close"

  Scenario: Logging outside lab does not show close button for experiments
    Given The request ip address is "172.16.4.80"
    And I am logged in as "userid4raul"
    And I am on the home page
    When I follow "View Details" for project "p1"
    And I follow "View Details"
    And I should not see "button will only be activated once the zip file has been downloaded"
    And I follow "Download Metadata"
    And I should not see link "Close"

  @javascript
  Scenario: Researcher can not show/download other's experiments
    Given I am logged in as "userid4luar"
    And I am on the view experiment page for "e1"
    Then I should see "You are not authorized to access this page"

  @javascript
  Scenario: Administrator can show/download other's experiments
    Given The request ip address is "172.16.4.80"
    And I am logged in as "userid4seanl"
    And I am on the view experiment page for "e1"
    And I follow "Download Metadata"
    Then I should not see link "Close"
    And I should not see "You are not authorized to access this page"

  @javascript
  Scenario: Supervisor can show/download supervised experiments
    Given The request ip address is "172.16.4.80"
    And I am logged in as "userid4supervisor"
    And I am on the view experiment page for "e1"
    And I follow "Download Metadata"
    Then I should not see link "Close"
    And I should not see "You are not authorized to access this page"

