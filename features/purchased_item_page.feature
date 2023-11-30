Feature: Item Page

  Background:
    Given I am logged in as "testuser"
    And I have valid payment methods and addresses
    Given I am on the "search" page
    Given there are categories created
    Given I have the following items for sale:
      | title          | description  | categories  | price |
      | Baseball       | temp         | Electronics | 1.00  |
      | Skis           | temp         | Books       | 1.00  |
    Given I have purchased the "Baseball" item
    Given I search for "Baseball"
    When I click on the item link

  Scenario: Accessing the Item Page
    Then I should see the purchased item page:
      | user       | title   | description  | price |
      | testuser   | Baseball| temp         | 1.00  |

