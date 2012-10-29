Feature: Malformation of Scenarios

  Scenario: Missing arguments table
    Given preconditions:
      | things |
    When an action
    Then a postcondition
