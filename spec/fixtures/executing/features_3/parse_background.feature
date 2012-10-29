Feature: Background instance variables are accessible in feature elements

  Background: Background
    Given I set an instance variable in a Background

  Scenario: Test
    When I check the instance variable
    Then it has the correct value
