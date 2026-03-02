@DB
Feature: Multi-Database Testing
  As a QA engineer
  I want to test against different database types
  So that I can ensure cross-database compatibility

  @DB @MySQL
  Scenario: Test MySQL database connection
    Given I set the active database profile to "mysql"
    And I have a database connection named "mysqldb" using profile "mysql"
    When I connect to the database "mysqldb"
    Then I should be connected to the database
    When I execute the query "SELECT DATABASE() as current_db"
    Then the query should execute successfully
    And the query should return 1 row(s)

  @DB @PostgreSQL
  Scenario: Test PostgreSQL database connection
    Given I set the active database profile to "postgresql"
    And I have a database connection named "postgresdb" using profile "postgresql"
    When I connect to the database "postgresdb"
    Then I should be connected to the database
    When I execute the query "SELECT current_database() as current_db"
    Then the query should execute successfully

  @DB @SQLServer
  Scenario: Test SQL Server database connection
    Given I set the active database profile to "sqlserver"
    And I have a database connection named "sqlserverdb" using profile "sqlserver"
    When I connect to the database "sqlserverdb"
    Then I should be connected to the database
    When I execute the query "SELECT DB_NAME() as current_db"
    Then the query should execute successfully

  @DB @Oracle
  Scenario: Test Oracle database connection
    Given I set the active database profile to "oracle"
    And I have a database connection named "oracledb" using profile "oracle"
    When I connect to the database "oracledb"
    Then I should be connected to the database
    When I execute the query "SELECT SYS_CONTEXT('USERENV', 'DB_NAME') as current_db FROM dual"
    Then the query should execute successfully
