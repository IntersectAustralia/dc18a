Feature: Locking out users after multiple failed password attempts
  In order prevent brute-force password guessing attacks
  As the system owner
  I want users to be locked out after 3 failed attempts

  Background:
    Given I have the usual roles and permissions
    And I have a user "userid4seanlin" with role "Administrator"

  Scenario: 3 consecutive failed logins results in account being locked.
    When I attempt to login with "userid4seanlin" and "blah"
    Then I should see "Invalid staff/student id or password."
    And I should be on the login page
    When I attempt to login with "userid4seanlin" and "blah"
    Then I should see "Invalid staff/student id or password."
    And I should be on the login page
    When I attempt to login with "userid4seanlin" and "blah"
    Then I should see "You entered an incorrect password 3 times in a row. For security reasons your account has been locked for one hour."

  Scenario: A successful login after 2 failures resets the failure count to zero
    When I attempt to login with "userid4seanlin" and "blah"
    Then I should see "Invalid staff/student id or password."
    When I attempt to login with "userid4seanlin" and "blah"
    Then I should see "Invalid staff/student id or password."
    And the failed attempt count for "userid4seanlin" should be "2"
    When I attempt to login with "userid4seanlin" and "Pas$w0rd"
    Then I should see "Logged in successfully."
    And the failed attempt count for "userid4seanlin" should be "0"
    When I follow "Logout"
    And I attempt to login with "userid4seanlin" and "blah"
    Then I should see "Invalid staff/student id or password."
    And the failed attempt count for "userid4seanlin" should be "1"

  Scenario: Can't login while locked even with correct password
    Given I have a locked user "userid4shuqian" with email "shuqian@intersect.org.au"
    When I attempt to login with "userid4shuqian" and "Pas$w0rd"
    And I should see "You entered an incorrect password 3 times in a row. For security reasons your account has been locked for one hour."
    And I should be on the login page

  Scenario: Further incorrect attempts while locked show locked message
    Given I have a locked user "userid4shuqian" with email "shuqian@intersect.org.au"
    When I attempt to login with "userid4shuqian" and "asdf"
    And I should see "You entered an incorrect password 3 times in a row. For security reasons your account has been locked for one hour."
    And I should be on the login page

  Scenario: Can login with correct password after lock expiring
    Given I have a user "userid4shuqian" with an expired lock
    When I attempt to login with "userid4shuqian" and "Pas$w0rd"
    Then I should see "Logged in successfully."
    And the failed attempt count for "userid4shuqian" should be "0"

  @wip
  Scenario: User can reset password while locked out and this resets the lock and failure count
    Given I have a locked user "userid4shuqian" with email "shuqian@intersect.org.au"
    When I attempt to login with "userid4shuqian" and "Pas$w0rd"
    Then I should see "You entered an incorrect password 3 times in a row. For security reasons your account has been locked for one hour."
    When I request a reset for "userid4shuqian"
    Then I should see "If the staff/student id you entered was valid, you will receive an email with instructions about how to reset your password in a few minutes."
    And "shuqian@intersect.org.au" should receive an email
    When I open the email
    Then I should see "Someone has requested a link to change your password on the DC18A site, and you can do this through the link below." in the email body
    When I follow "Change my password" in the email
    Then I should see "Change Your Password"
    When I fill in "Password" with "Pass.456"
    And I fill in "Confirm Password" with "Pass.456"
    And I press "Change Your Password"
    Then I should see "Your password was changed successfully. You are now signed in."
    # to verify we are actually logged in
    And I should not see "Login"
    And the failed attempt count for "userid4shuqian" should be "0"
    And I should be able to log in with "userid4shuqian" and "Pass.456"

