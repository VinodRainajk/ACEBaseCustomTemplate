@Bundle
Feature: Bundles - Google search
  Matching tag: @bundle:googleSearch — put the same tag on the BA scenario.
  BA markers live under the scenario; each one is a sentence the BA can write.

  @bundle:googleSearch
  Scenario: Search Google
    # BA: the user searches Google for {string}
    When I launch the url "https://www.google.com"
    And I click the element "xpath=//button[normalize-space()='Accept all']" if it is visible
    And I click the element "xpath=//button[normalize-space()='I agree']" if it is visible
    And I enter "<0>" in the field "name=q"
    And I press enter in the field "name=q"

    # BA: the Google results mention {string}
    Then I wait for the element "id=search" to be visible
    And the page title should contain "<0>"
    And the page should contain the text "<0>"
