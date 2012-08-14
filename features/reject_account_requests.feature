Feature: Reject access requests
  In order to manage the system
  As an administrator
  I want to reject access requests
  
  Background:
    Given I have the usual roles and permissions
    And I have a user "userid4seanlin"
    And "userid4seanlin" has role "Administrator"
    And I have access requests
      |user_id | email                  | first_name | last_name        |
      |userid4ryan      | ryan@intersect.org.au  | Ryan       | Braganza         |
      |userid4diego     | diego@intersect.org.au | Diego      | Alonso de Marcos |
    And I am logged in as "userid4seanlin"

  Scenario: Reject an access request from the list page
    Given I am on the access requests page
    When I follow "Reject" for "userid4diego"
    Then I should see "The access request for userid4diego was rejected."
    And I should see "access_requests" table with
      |Staff/Student ID | First Name | Last Name | Email                 |
      |userid4ryan      | Ryan       | Braganza  | ryan@intersect.org.au |
    And "diego@intersect.org.au" should receive an email with subject "DC18A - Your access request has been rejected"
    When I open the email
    Then I should see "You made a request for access to the DC18A System. Your request has been rejected. Please contact the DC18A team for further information." in the email body
    And I should see "Hello Diego Alonso de Marcos," in the email body

  Scenario: Reject an access request as spam from the list page
    Given I am on the access requests page
    When I follow "Reject as Spam" for "userid4diego"
    Then I should see "The access request for userid4diego was rejected and this staff/student id will be permanently blocked."
    And I should see "access_requests" table with
      |Staff/Student ID | First Name | Last Name | Email                 |
      |userid4ryan      | Ryan       | Braganza  | ryan@intersect.org.au |
    And "diego@intersect.org.au" should receive an email with subject "DC18A - Your access request has been rejected"
    When they open the email
    Then they should see "You made a request for access to the DC18A System. Your request has been rejected. Please contact the DC18A team for further information." in the email body
    And they should see "Hello Diego Alonso de Marcos," in the email body

  Scenario: Reject an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "userid4diego"
    And I follow "Reject"
    Then I should see "The access request for userid4diego was rejected."
    And I should see "access_requests" table with
      |Staff/Student ID | First Name | Last Name | Email                 |
      |userid4ryan      | Ryan       | Braganza  | ryan@intersect.org.au |

  Scenario: Reject an access request as spam from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "userid4diego"
    And I follow "Reject as Spam"
    Then I should see "The access request for userid4diego was rejected and this staff/student id will be permanently blocked."
    And I should see "access_requests" table with
      |Staff/Student ID | First Name | Last Name | Email                 |
      |userid4ryan      | Ryan       | Braganza  | ryan@intersect.org.au |

  Scenario: Rejected user should not be able to log in
    Given I am on the access requests page
    When I follow "Reject" for "userid4diego"
    And I am on the home page
    And I follow "Logout"
    And I am on the login page
    And I fill in "Staff/Student ID" with "userid4diego"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Invalid staff/student id or password."
    And I should be on the login page

  Scenario: Rejected as spam user should not be able to log in
    Given I am on the access requests page
    When I follow "Reject as Spam" for "userid4diego"
    And I am on the home page
    And I follow "Logout"
    And I am on the login page
    And I fill in "Staff/Student ID" with "userid4diego"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Your account is not active."
    And I should be on the login page

  Scenario: Rejected user should be able to apply again
    Given I am on the access requests page
    When I follow "Reject" for "userid4diego"
    And I am on the home page
    And I follow "Logout"
    And I am on the request account page
    And I fill in the following:
      | Staff/Student ID      | userid4diego           |
      | Email                 | diego@intersect.org.au |
      | Password              | Pas$w0rd               |
      | Confirm Password      | Pas$w0rd               |
      | First Name            | Fred                   |
      | Last Name             | Bloggs                 |
    And I press "Submit Request"
    Then I should see "Thanks for requesting an account. You will receive an email when your request has been approved."

  Scenario: Rejected as spam user should not be able to apply again
    Given I am on the access requests page
    When I follow "Reject as Spam" for "userid4diego"
    And I am on the home page
    And I follow "Logout"
    And I am on the request account page
    And I fill in the following:
      | Staff/Student ID      | userid4diego           |
      | Email                 | diego@intersect.org.au |
      | Password              | Pas$w0rd               |
      | Confirm Password      | Pas$w0rd               |
      | First Name            | Fred                   |
      | Last Name             | Bloggs                 |
    And I press "Submit Request"
    Then I should see "has already been taken"

