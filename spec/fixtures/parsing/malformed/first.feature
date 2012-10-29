Feature: Malformation of Scenario Outlines

  Scenario Outline: Missing examples
    Given a <object>
    When I listen
    Then I hear <sound>

  Scenario Outline: Missing example table
    Given an <object>
    When I look at it
    Then it is <colour>
  Examples:

  Scenario Outline: Example table with no rows
    Given an <object>
    When I look at it
    Then it is <colour>
  Examples:
    | colour | object    |
