@API @WaitPollingSample @all
Feature: API wait and polling sample

  Scenario: Wait and poll last API response until status-like field is ready
    Given I have the API base URL "https://jsonplaceholder.typicode.com"
    When I send a GET request to "/users/1"
    Then the response status code should be 200
    And I wait for 1 seconds before next step
    And I wait up to 10 seconds for the last API response to have "id" as "1", checking every 500 milliseconds
