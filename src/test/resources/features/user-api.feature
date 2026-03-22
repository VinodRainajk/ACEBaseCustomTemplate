@API
Feature: User API using feature payload YAML

  Paths and JSON bodies live in user-api_payload.yml. Use the two-step pattern:
  "When I set the body from feature payload..." then "And I send a POST/PUT/PATCH request to path from feature payload..."

  Background:
    Given the API base URL from config

  Scenario: Fetch user (no body)
    When I send a GET request to path from feature payload "paths.user_by_id"
    Then the response status code should be 200
    And the response body should contain "Leanne Graham"

  Scenario: Create user with body from payload YAML
    When I set the body from feature payload "bodies.create_user"
    And I send a POST request to path from feature payload "paths.users"
    Then the response status code should be 201

  Scenario: Update user with body from payload YAML
    When I set the body from feature payload "bodies.update_user"
    And I send a PUT request to path from feature payload "paths.user_by_id"
    Then the response status code should be 200

  Scenario: Partial update with PATCH
    When I set the body from feature payload "bodies.patch_user"
    And I send a PATCH request to path from feature payload "paths.user_by_id"
    Then the response status code should be 200

  Scenario: Create post with body from payload YAML
    When I set the body from feature payload "bodies.create_post"
    And I send a POST request to path from feature payload "paths.posts"
    Then the response status code should be 201
    And the response JSON path "id" should exist
