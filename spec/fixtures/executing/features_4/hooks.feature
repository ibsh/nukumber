Feature: Scenarios

  Scenario: Checking the before hook
    When I check for a variable set up by the hook
    Then I should find it

  @tagged
  Scenario: Checking the tagged before hook
    When I check for a variable set up by the hook
    Then I should find it

  Scenario: Checking the after hook
    When I set up a variable for the after hook

  @tagged
  Scenario: Checking the tagged after hook
    When I set up a variable for the after hook

  Scenario: Before and After for a failed test
    When I fail