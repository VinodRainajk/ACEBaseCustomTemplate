@API @Smoke @all
Feature: API Sample - Placeholder for API tests
  As a QA Engineer
  I want to verify API endpoints
  So that the API works correctly

  Scenario: GET request returns success
    Given I have the API base URL "https://jsonplaceholder.typicode.com"
    When I send a GET request to "/users/1"
    Then the response status code should be 200
