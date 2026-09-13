@Bundle
Feature: Bundles - Practice site login
  Bundle name: @bundle:practiceLogin. BA scenarios tag @declarative:practiceLogin.
  Site: https://the-internet.herokuapp.com/login — no CAPTCHA.

  @bundle:practiceLogin
  Scenario: Practice login
    # BA: the user logs into the practice site as {string} with password {string}
    When I launch the url "https://the-internet.herokuapp.com/login"
    And I enter "<0>" in the field "id=username"
    And I enter "<1>" in the field "id=password"
    And I click on the element "css=button[type=submit]"

    # BA: the practice site shows the secure area
    Then I wait for the element "id=flash" to be visible
    And the element "id=flash" should contain the text "You logged into a secure area"
    And the current url should contain "/secure"
