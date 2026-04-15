@DB @CsvCompare @all
Feature: Compare SQL results with CSV samples

  Background:
    Given I connect to database "mysql-world"

  Scenario: Query result should match expected CSV in order
    When I execute the query "{queries.city_count}"
    Then the query result should match CSV from feature payload "expected.city_count_ordered" in order

  Scenario: Query result should not match mismatch CSV in order
    When I execute the query "{queries.city_count}"
    Then the query result should not match CSV from feature payload "expected.city_count_mismatch" in order

  Scenario: Export CSV mismatch report with remarks
    When I execute the query "{queries.city_count}"
    Then the query result should match CSV from feature payload "expected.city_count_mismatch"
    And I export CSV mismatches with remarks to "target/csv-failures/world-city-mismatch-report.csv"
