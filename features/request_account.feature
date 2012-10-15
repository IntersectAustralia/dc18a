@javascript
Feature: Request an account
  In order to use the system
  As a user
  I want to request an account

  Background:
    Given I have no users
    Given I have the usual roles and permissions
    And I have administrators
      | user_id        | email                  | first_name | last_name |
      | userid4seanlin | seanl@intersect.org.au | Sean       | Lin       |
    And I have supervisors
      | user_id            | email                        | first_name | last_name |
      | userid4supervisor1 | supervisor1@intersect.org.au | Supervisor | 1         |
      | userid4supervisor2 | supervisor2@intersect.org.au | Supervisor | 2         |

  Scenario: Request account
    Given I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4georgina           |
      | Email             | georgina@intersect.org.au |
      | Password          | paS$w0rd                  |
      | Confirm Password  | paS$w0rd                  |
      | Given Name        | Fred                      |
      | Surname           | Bloggs                    |
    And I select "Pharmacy" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    Then I should see "Thanks for requesting an account. You will receive an email when your request has been approved."
    And I should not see "Your account is not active"
    And I should be on the home page
    And I should see "Please enter your staff/student id and password to log in"

  Scenario: Email to superuser upon account request and clicking through to access requests page
    Given I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4georgina           |
      | Email             | georgina@intersect.org.au |
      | Password          | paS$w0rd                  |
      | Confirm Password  | paS$w0rd                  |
      | Given Name        | Fred                      |
      | Surname           | Bloggs                    |
    And I select "Pharmacy" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    Then "seanl@intersect.org.au" should receive an email with subject "DC18A - There has been a new access request"
    When they open the email
    Then they should see "An access request has been made with the following details:" in the email body
    And they should see "Staff/Student ID: userid4georgina" in the email body
    And they should see "Email: georgina@intersect.org.au" in the email body
    And they should see "Given Name: Fred" in the email body
    And they should see "Surname: Bloggs" in the email body
    And they should see "You can view unapproved access requests here" in the email body
    When they click the first link in the email
    Then I should be on the login page
    And I fill in "Staff/Student ID" with "userid4seanlin"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | Staff/Student ID | Given Name | Surname | Email                     |
      | userid4georgina  | Fred       | Bloggs  | georgina@intersect.org.au |

  Scenario: Requesting an account with mismatched password confirmation should be rejected
    Given I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4georgina           |
      | Email             | georgina@intersect.org.au |
      | Password          | paS$w0rd                  |
      | Confirm Password  | dr0w$Sap                  |
      | Given Name        | Fred                      |
      | Surname           | Bloggs                    |
    And I select "Pharmacy" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    And the "Password" field should have the error "doesn't match confirmation"
    And the "Given Name" field should have no errors
    And the "Surname" field should have no errors
    And the "Email" field should have no errors
    And the "School/Institute" field should have no errors
    And the "Supervisors" field should have no errors

  Scenario: Password fields should be cleared out on validation error
    Given I am on the request account page
    When I fill in the following:
      | Email            | georgina@intersect.org.au |
      | Password         | paS$w0rd                  |
      | Confirm Password | paS$w0rd                  |
    And I press "Submit Request"
    And the "Staff/Student ID" field should have the error "can't be blank"
    And the "Given Name" field should have the error "can't be blank"
    And the "Surname" field should have the error "can't be blank"
    And the "Password" field should contain ""
    And the "Confirm Password" field should contain ""

  Scenario: Newly requested account should not be able to log in yet
    Given I am on the request account page
    And I fill in the following:
      | Staff/Student ID  | userid4georgina           |
      | Email             | georgina@intersect.org.au |
      | Password          | paS$w0rd                  |
      | Confirm Password  | paS$w0rd                  |
      | Given Name        | Fred                      |
      | Surname           | Bloggs                    |
    And I select "Pharmacy" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    And I am on the login page
    When I fill in "Staff/Student ID" with "userid4georgina"
    And I fill in "Password" with "paS$w0rd"
    And I press "Log in"
    Then I should see "Your account is not active."
    And I should be on the login page

  Scenario: Deactivated supers shouldn't get the email
    Given I have administrators
      | user_id     | email                 |
      | userid4fred | fred@intersect.org.au |
    And "userid4fred" is deactivated
    And I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4georgina           |
      | Email             | georgina@intersect.org.au |
      | Password          | paS$w0rd                  |
      | Confirm Password  | paS$w0rd                  |
      | Given Name        | Fred                      |
      | Surname           | Bloggs                    |
    And I select "Pharmacy" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    Then "seanl@intersect.org.au" should receive an email with subject "DC18A - There has been a new access request"
    Then "fred@intersect.org.au" should receive no emails

  Scenario: Requesting an account with existed Staff/Student ID should be rejected
    Given I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4seanlin         |
      | Email             | seanl@intersect.org.au |
      | Password          | paS$w0rd               |
      | Confirm Password  | paS$w0rd               |
      | Given Name        | Sean                   |
      | Surname           | Lin                    |
    And I select "Pharmacy" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    And the "Staff/Student ID" field should have the error "has already been taken"

  Scenario: Requesting an account without select supervisor should be rejected
    Given I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4seanlin         |
      | Email             | seanl@intersect.org.au |
      | Password          | paS$w0rd               |
      | Confirm Password  | paS$w0rd               |
      | Given Name        | Sean                   |
      | Surname           | Lin                    |
    And I select "Pharmacy" from "School/Institute"
    And I press "Submit Request"
    And the "Supervisors" field should have the error "can't be blank"

  @javascript
  Scenario: Signing up with "Other (Specify)" selected for "School/Institute" and not input in "Specify Other School/Institute" should be rejected
    Given I am on the request account page
    When I fill in the following:
      | Staff/Student ID  | userid4seanlin         |
      | Email             | seanl@intersect.org.au |
      | Password          | paS$w0rd               |
      | Confirm Password  | paS$w0rd               |
      | Given Name        | Sean                   |
      | Surname           | Lin                    |
    And I select "Other (Specify)" from "School/Institute"
    And I select "Supervisor 1" from "Supervisors"
    And I select "Supervisor 2" from "Supervisors"
    And I press "Submit Request"
    Then the "Specify Other School/Institute" field should have the error "can't be blank"
    And the "School/Institute" field should have no errors
