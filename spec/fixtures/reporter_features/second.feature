Feature: Reporting on features (2)

  Background: Some background
    Given a setup step
    And another setup step

  Scenario: b1
    Given a precondition
    When an action
    Then a postcondition

  Scenario Outline: b2
    Given an <object>
    When I look at it
    Then it is <colour>
  Examples:
    | colour | object    |
    | white  | flag      |
    | red    | rag       |
    | yellow | submarine |
