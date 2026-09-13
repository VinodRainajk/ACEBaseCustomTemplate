@Google @driver @all
Feature: Google search
  BA view. @declarative:googleSearch matches @bundle:googleSearch in the bundle.
  The BA markers live in bundles/google-search.feature, not here.

  @declarative:googleSearch
  Scenario: A visitor finds a term
    When the user searches Google for "vinod"
    Then the Google results mention "vinod"
