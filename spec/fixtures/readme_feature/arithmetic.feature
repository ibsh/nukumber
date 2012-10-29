Feature: Ruby arithmetic functions

  Scenario Outline: Addition
    Given I have integers <a> and <b>
    When I add them
    Then the result is <result>
  Examples: Easy sums
    | a | b | result |
    | 1 | 2 | 3      |
    | 5 | 9 | 14     |
