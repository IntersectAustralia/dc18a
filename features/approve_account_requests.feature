Feature: Approve access requests
  In order to allow users to access the system
  As an administrator
  I want to approve access requests

  Background:
    Given I have roles
      | name       |
      | Administrator  |
      | Researcher |
    And I have permissions
      | entity | action          | roles  |
      | User   | read            | Administrator |
      | User   | admin           | Administrator |
      | User   | reject          | Administrator |
      | User   | approve         | Administrator |
    And I have a user "userid4seanlin" with role "Administrator"
    And I have access requests
      | user_id                | email                  | first_name | last_name        |
      | userid4ryan            | ryan@intersect.org.au  | Ryan       | Braganza         |
      | userid4diego           | diego@intersect.org.au | Diego      | Alonso de Marcos |
    And I have editors
      | name   | text                |
      | footer | Initial footer text |
    And I am logged in as "userid4seanlin"

  Scenario: View a list of access requests
    Given I am on the access requests page
    Then I should see "access_requests" table with
      |Staff/Student ID | Given Name | Surname          | Email                  |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au |
      |userid4ryan      | Ryan       | Braganza         | ryan@intersect.org.au  |

  Scenario: Approve an access request from the list page
    Given I am on the access requests page
    When I follow "Approve" for "userid4diego"
    And I select "Administrator" from "Role"
    And I press "Approve"
    Then I should see "The access request for userid4diego was approved."
    And I should see "access_requests" table with
      |Staff/Student ID | Given Name | Surname   | Email                 |
      |userid4ryan      | Ryan       | Braganza  | ryan@intersect.org.au |
    And "diego@intersect.org.au" should receive an email with subject "DC18A - Your access request has been approved"
    When they open the email
    Then they should see "You made a request for access to the DC18A System. Your request has been approved. Please visit" in the email body
    And they should see "Hello Diego Alonso de Marcos," in the email body
    When they click the first link in the email
    Then I should be on the home page

  Scenario: Cancel out of approving an access request from the list page
    Given I am on the access requests page
    When I follow "Approve" for "userid4diego"
    And I select "Administrator" from "Role"
    And I follow "Back"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      |Staff/Student ID | Given Name | Surname          | Email                  |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au |
      |userid4ryan      | Ryan       | Braganza         | ryan@intersect.org.au  |

  Scenario: View details of an access request
    Given I am on the access requests page
    When I follow "View Details" for "userid4diego"
    Then I should see field "Staff/Student ID" with value "userid4diego"
    Then I should see field "Email" with value "diego@intersect.org.au"
    Then I should see field "Given Name" with value "Diego"
    Then I should see field "Surname" with value "Alonso de Marcos"
    Then I should see field "Role" with value ""
    Then I should see field "Status" with value "Pending Approval"

  Scenario: Approve an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "userid4diego"
    And I follow "Approve"
    And I select "Administrator" from "Role"
    And I press "Approve"
    Then I should see "The access request for userid4diego was approved."
    And I should see "access_requests" table with
      |Staff/Student ID | Given Name | Surname   | Email                 |
      |userid4ryan      | Ryan       | Braganza  | ryan@intersect.org.au |

  Scenario: Cancel out of approving an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "userid4diego"
    And I follow "Approve"
    And I select "Administrator" from "Role"
    And I follow "Back"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      |Staff/Student ID | Given Name | Surname          | Email                  |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au |
      |userid4ryan      | Ryan       | Braganza         | ryan@intersect.org.au  |

  Scenario: Go back to the access requests page from the view details page without doing anything
    Given I am on the access requests page
    And I follow "View Details" for "userid4diego"
    When I follow "Back"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      |Staff/Student ID | Given Name | Surname          | Email                  |
      |userid4diego     | Diego      | Alonso de Marcos | diego@intersect.org.au |
      |userid4ryan      | Ryan       | Braganza         | ryan@intersect.org.au  |

  Scenario: Role should be mandatory when approving an access request
    Given I am on the access requests page
    When I follow "Approve" for "userid4diego"
    And I press "Approve"
    Then I should see "Please select a role for the user."

  Scenario: Approved user should be able to log in
    Given I am on the access requests page
    When I follow "Approve" for "userid4diego"
    And I select "Administrator" from "Role"
    And I press "Approve"
    And I am on the home page
    And I follow "Logout"
    Then I should be able to log in with "userid4diego" and "Pass.123"

  Scenario: Approved user roles should be correctly saved
    Given I am on the access requests page
    And I follow "Approve" for "userid4diego"
    And I select "Administrator" from "Role"
    And I press "Approve"
    And I am on the list users page
    When I follow "View Details" for "userid4diego"
    And I should see field "Role" with value "Administrator"
