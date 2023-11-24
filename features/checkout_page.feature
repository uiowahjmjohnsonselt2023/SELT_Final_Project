Feature: Checkout Screen Rendering

  Background:
    Given I am logged in as "checkout-user"
    Given there are categories created
    Given "temp-user" has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    Given I am on the "search" page
    Given I search for "Baseball"
    When I click on the "Baseball" link





