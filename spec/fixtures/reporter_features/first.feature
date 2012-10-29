@overtag
Feature: Reporting on features (1)
  Here are a couple of lines
  commenting on the feature.

  Scenario: a1
    Comments on the first scenario
    go onto multiple lines.
    Given one
    When two
    Then three

  @undertag
  Scenario: a2
    Given these:
      | thing |
      | a     |
      | b     |
    When this
    Then that

  Scenario Outline: a3
    Given a <object>
    When I listen
    Then I hear <sound>
  Examples:
    | object | sound |
    | cat    | miaow |
    | dog    | woof  |
    | ball   | boing |

  @multiple @tags
  Scenario Outline: a4
    Just one line of commentary on the fourth scenario.
    Given a <object>
    When I do these things to it:
      | action |
      | prod   |
      | poke   |
      | smack  |
    Then its response is <response>
  Examples:
    | object | response |
    | cat    | vengeful |
    | dog    | dismayed |
    | ball   | stoic    |