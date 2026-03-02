@DB
Feature: User Management Database Tests
  As a QA engineer
  I want to validate user management operations
  So that I can ensure data integrity

  Background:
    Given I set the active database profile to "mysql"
    And I have a database connection named "userdb" using profile "mysql"
    And I connect to the database "userdb"

  @DB @UserManagement @Smoke
  Scenario: Verify active users count
    When I execute the query "SELECT COUNT(*) as total FROM users WHERE status = 'active'"
    Then the query should execute successfully
    And the query should return 1 row(s)

  @DB @UserManagement @Regression
  Scenario: Verify user details by ID
    When I execute the query "SELECT id, name, email, status FROM users WHERE id = 1"
    Then the query should return 1 row(s)
    And the first row should contain column "status" with value "active"
    And the result set should contain a column "name"
    And the result set should contain a column "email"

  @DB @UserManagement @Regression
  Scenario: Verify all users have required fields
    When I execute the query "SELECT id, name, email FROM users LIMIT 10"
    Then the query should execute successfully
    And all rows should have column "id" not null
    And all rows should have column "name" not null
    And all rows should have column "email" not null

  @DB @UserManagement @Smoke
  Scenario: Search users by email domain
    When I execute the query "SELECT * FROM users WHERE email LIKE '%@example.com'"
    Then the query should execute successfully
    And the query should return at least 1 row(s)
