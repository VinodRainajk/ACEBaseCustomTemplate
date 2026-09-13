@Practice @driver @all
Feature: Practice site login
  BA view. @declarative:practiceLogin matches @bundle:practiceLogin in the bundle.
  Uses the-internet.herokuapp.com so the run is not blocked by a CAPTCHA.

  @declarative:practiceLogin
  Scenario: A known user reaches the secure area
    When the user logs into the practice site as "tomsmith" with password "SuperSecretPassword!"
    Then the practice site shows the secure area
    And the page should contain the text "Secure Area"

  Scenario: The same login using atomic steps only
    When I launch the url "https://the-internet.herokuapp.com/login"
    And I enter "tomsmith" in the field "id=username"
    And I enter "SuperSecretPassword!" in the field "id=password"
    And I click on the element "css=button[type=submit]"
    Then the page should contain the text "Secure Area"
