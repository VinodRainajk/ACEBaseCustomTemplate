@DB @MySQL
Feature: Environment-Based Database Testing
  As a QA engineer
  I want to test the same scenarios across different environments
  So that I can ensure consistency

  @DB @MySQL @Dev
  Scenario: Test Development Environment Database
    Given I set the active database profile to "mysql-dev"
    And I have a database connection named "devdb" using profile "mysql-dev"
    When I connect to the database "devdb"
    Then I should be connected to the database
    When I execute the query "SELECT * FROM users WHERE environment = 'dev'"
    Then the query should execute successfully

  @DB @MySQL @Test
  Scenario: Test Test Environment Database
    Given I set the active database profile to "mysql-test"
    And I have a database connection named "testdb" using profile "mysql-test"
    When I connect to the database "testdb"
    Then I should be connected to the database
    When I execute the query "SELECT * FROM users WHERE environment = 'test'"
    Then the query should execute successfully

  @DB @MySQL @Staging
  Scenario: Test Staging Environment Database
    Given I set the active database profile to "mysql-staging"
    And I have a database connection named "stagingdb" using profile "mysql-staging"
    When I connect to the database "stagingdb"
    Then I should be connected to the database
    When I execute the query "SELECT * FROM users WHERE environment = 'staging'"
    Then the query should execute successfully
