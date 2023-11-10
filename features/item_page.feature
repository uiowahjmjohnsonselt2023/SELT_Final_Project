Feature: Item Page
  Scenario: Accessing the Item Page
    Given I am logged in as a regular user
    When I go to the item page
    Then I should see the item page
