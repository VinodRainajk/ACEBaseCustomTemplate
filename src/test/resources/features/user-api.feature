@API @Smoke
Feature: User API - Sample API tests with config and payloads
  As a QA Engineer
  I want to test the User API endpoints
  So that I can verify API functionality using config and external payloads

  Background:
    Given the API base URL from config

  Scenario: GET user by ID - uses base URL from master.yaml
    When I send a GET request to "/users/1"
    Then the response status code should be 200
    And the response body should contain "Leanne Graham"
    And the response JSON path "id" should exist
    And the response JSON path "id" should equal 1

  Scenario: Create user with payload - uses payload user/create-user
    When I send a POST request to "/users" with payload "user/create-user"
    Then the response status code should be 201

  Scenario: Update user with payload - uses payload user/update-user
    When I send a PUT request to "/users/1" with payload "user/update-user"
    Then the response status code should be 200

  Scenario: Create post with payload - uses payload post/create-post
    When I send a POST request to "/posts" with payload "post/create-post"
    Then the response status code should be 201
    And the response JSON path "id" should exist
