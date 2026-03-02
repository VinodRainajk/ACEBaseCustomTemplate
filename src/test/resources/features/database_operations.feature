@DB
Feature: Database Operations
  As a QA engineer
  I want to execute database operations
  So that I can validate data in the database

  Background:
    Given I set the active database profile to "mysql"
    And I have a database connection named "testdb" using profile "mysql"
    And I connect to the database "testdb"

  @DB @Smoke
  Scenario: Execute a simple SELECT query
    When I execute the query "SELECT * FROM users WHERE status = 'active'"
    Then the query should execute successfully
    And the query should return at least 1 row(s)

  @DB @Regression
  Scenario: Verify specific data in query results
    When I execute the query "SELECT id, name, email FROM users WHERE id = 1"
    Then the query should return 1 row(s)
    And the first row should contain column "name" with value "John Doe"
    And the first row should contain column "email" with value "john.doe@example.com"

  @DB @Regression
  Scenario: Execute an UPDATE query
    When I execute the update query "UPDATE users SET last_login = NOW() WHERE id = 1"
    Then the update should affect 1 row(s)

  @DB @Smoke
  Scenario: Verify column existence in results
    When I execute the query "SELECT id, name, email, created_at FROM users LIMIT 5"
    Then the query should execute successfully
    And the result set should contain a column "id"
    And the result set should contain a column "name"
    And the result set should contain a column "email"
    And the result set should contain a column "created_at"

  @DB @Regression
  Scenario: Verify non-null values
    When I execute the query "SELECT id, name FROM users WHERE status = 'active'"
    Then the query should execute successfully
    And all rows should have column "id" not null
    And all rows should have column "name" not null

  @DB @Smoke
  Scenario: Test database connection
    Then I should be connected to the database
    When I disconnect from the database
    Then I should not be connected to the database
