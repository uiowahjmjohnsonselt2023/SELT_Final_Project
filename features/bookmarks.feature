Feature: Bookmarking functionality
  Scenario: Adding a bookmark
    Given I am logged in as "newuser"
    Given I am on the "search" page
    Given there are categories created
    Given a user has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    Given I search for "Baseball"
