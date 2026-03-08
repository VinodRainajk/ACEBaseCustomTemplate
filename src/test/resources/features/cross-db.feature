/git @DB
Feature: Cross-database data comparison
  Compare data between MySQL and Oracle using config names from YAML
  Config: master_database.yml + cross-db-database.yml (feature override) + sections (scenario override)

  Scenario: Single database query - uses mysql from master + feature override
    Given I connect to database "mysql"
    When I execute the query "SELECT 1 as one"
    Then the query should return 1 row

  Scenario: Compare user counts across MySQL and Oracle
    Given I connect to database "mysql"
    And I connect to database "oracle" as "oracle_conn"
    When I execute the query "SELECT COUNT(*) as user_count FROM users" on "mysql"
    And I execute the query "SELECT COUNT(*) as user_count FROM users" on "oracle_conn"
    Then the result row count from "mysql" should equal the result row count from "oracle_conn"

  Scenario: Two databases same feature config
    Given I connect to database "mysql"
    And I connect to database "oracle"
    When I execute the query "SELECT 1 as one" on "mysql"
    And I execute the query "SELECT 1 as one FROM DUAL" on "oracle"
    Then the query on "mysql" should return 1 row
    And the query on "oracle" should return 1 row
