Feature: Item Page
  Background:
    Given I am logged in as a regular user
    Given I am on the "search" page
    Given there are categories created
    Given I have the following items for sale:
      | title          | description  | categories  | price |
      | Baseball       | temp         | Electronics | 1.00  |
      | Skis           | temp         | Books       | 1.00  |
    Given I search for "Baseball"
    When I click on the item link
  Scenario: Accessing the Item Page
    Then I should see the item page
    Then I should see the item "Baseball"
    Then I should see the item "temp"
    Then I should see the item "Listed by: testuser"
    Then I should see the item "Skis"
