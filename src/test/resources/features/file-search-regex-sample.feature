@FileSearchSample @all
Feature: File search and regex validation samples

  Scenario: Validate report file exists by exact name
    Then file "api-tests.json" should exist in path "target/cucumber-reports"

  Scenario: Validate files exist by glob and regex
    Then at least 1 files matching "*.json" should exist in path "target/cucumber-reports"
    And at least 1 files matching regex ".*\\.json$" should exist in path "target/cucumber-reports"

  Scenario: Capture first matching file and validate captured path
    Then I capture first file matching regex ".*\\.html$" in path "target/cucumber-reports" as "report_file"
    And captured file path "report_file" should match regex ".*cucumber-reports.*\\.html$"

  Scenario: Validate non-existing file
    Then file "does-not-exist.txt" should not exist in path "target/cucumber-reports"
