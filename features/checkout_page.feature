Feature: Checkout Screen Rendering

  Background:
    Given I am logged in as "testuser"
    Given I am on the "search" page
    Given a user has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    Given I search for "Baseball"
    When I click on the item link
    When I click on the Buy Now button



  Scenario: Accessing the checkout screen
    Then I should see the checkout page


