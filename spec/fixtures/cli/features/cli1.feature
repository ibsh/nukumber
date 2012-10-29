@ubertag @ubertag2
Feature: Scenarios

  Scenario: CLI 1 (part 1)
    Given a precondition
    When an action
    Then a postcondition

  Scenario: CLI 1 (part 2)
    Given some stuff:
      | variable | value |
      | a        | 5     |
      | b        | 3     |
      | c        | 8     |
    When an action
    Then a postcondition

  @tagged
  Scenario: CLI 1 (part 3)
    Given a precondition
    When an action
    Then a postcondition