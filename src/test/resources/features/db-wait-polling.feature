@DB @WaitPollingSampleDB @all
Feature: DB wait and polling sample

  Background:
    Given I connect to database "mysql-world"

  Scenario: Wait and poll query until minimum rows are present
    Then I wait for 1 seconds before next step
    And I wait up to 20 seconds for query "{queries.city_count}" to return at least 1 rows, checking every 500 milliseconds
