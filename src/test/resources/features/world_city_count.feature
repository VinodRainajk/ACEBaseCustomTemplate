@DB @Smoke @all
Feature: World Database - City Count Verification
  As a QA Engineer
  I want to verify the city count in the world database
  So that I can ensure data integrity

  Background:
    Given I connect to database "mysql-world"

  @CityCount @Positive
  Scenario: Count total number of cities in world database
    When I execute the query "SELECT COUNT(*) as city_count FROM city"
    Then the query should return 1 rows
    And the result set should contain a column "city_count"

  @CityCount @FileRef
  Scenario: Count total cities using SQL file referenced from feature payload YAML
    When I execute the query "{queries.total_cities_file}"
    Then the query should return 1 rows
    And the result set should contain a column "city_count"

  @CityCount @Validation
  Scenario: Verify city count is greater than zero
    When I execute the query "SELECT COUNT(*) as total_cities FROM city"
    Then the query should return 1 rows
    And the first row should contain column "total_cities" with value greater than "0"

  @CityData @Positive
  Scenario: Retrieve all cities and verify data structure
    When I execute the query "SELECT * FROM city LIMIT 10"
    Then the query should return 10 rows
    And the result set should contain a column "ID"
    And the result set should contain a column "Name"
    And the result set should contain a column "CountryCode"
    And the result set should contain a column "District"
    And the result set should contain a column "Population"

  @CityCount @CountrySpecific
  Scenario: Count cities in a specific country (USA)
    When I execute the query "SELECT COUNT(*) as usa_cities FROM city WHERE CountryCode = 'USA'"
    Then the query should return 1 rows
    And the result set should contain a column "usa_cities"

  @CityData @LargePopulation
  Scenario: Find cities with population greater than 1 million
    When I execute the query "SELECT COUNT(*) as large_cities FROM city WHERE Population > 1000000"
    Then the query should return 1 rows
    And the result set should contain a column "large_cities"

  @CityData @TopCities
  Scenario: Retrieve top 5 most populated cities
    When I execute the query "SELECT Name, Population FROM city ORDER BY Population DESC LIMIT 5"
    Then the query should return 5 rows
    And the result set should contain a column "Name"
    And the result set should contain a column "Population"
    And all rows should have column "Name" not null
    And all rows should have column "Population" not null

  @CityData @NullCheck
  Scenario: Verify no cities have null names
    When I execute the query "SELECT COUNT(*) as null_name_count FROM city WHERE Name IS NULL"
    Then the query should return 1 rows
    And the first row should contain column "null_name_count" with value "0"

  @CityData @DistinctCountries
  Scenario: Count distinct countries with cities
    When I execute the query "SELECT COUNT(DISTINCT CountryCode) as country_count FROM city"
    Then the query should return 1 rows
    And the result set should contain a column "country_count"

  @CityCount @PayloadDemo @TwoStep
  Scenario: Count total cities using two-step feature payload
    When I set the SQL statement from feature payload "queries.count_cities"
    And I execute the query
    Then the query should return 1 rows
    And the result set should contain a column "city_count"

  @CityCount @PayloadDemo @TwoStep
  Scenario: Count total cities via total_cities key
    When I set the SQL statement from feature payload "queries.total_cities"
    And I execute the query
    Then the query should return 1 rows
    And the result set should contain a column "city_count"

  @CityData @TwoStep @Prepared
  Scenario: Retrieve city by ID using prepared statement from payload
    When I set the prepared statement from feature payload "prepared.city_by_id"
    And I execute the prepared query
    Then the query should return 1 rows
    And the result set should contain a column "ID"
    And the result set should contain a column "Name"
    And the result set should contain a column "Population"

  @CityData @TopCities @TwoStep
  Scenario: Retrieve top 5 cities using two-step payload
    When I set the SQL statement from feature payload "queries.top_cities"
    And I execute the query
    Then the query should return 5 rows
    And the result set should contain a column "Name"
    And the result set should contain a column "Population"

  @Cleanup
  Scenario: Disconnect from database after tests
    When I disconnect from the database
    Then I should not be connected to the database
