Feature: Seeing the search results
  Background: Searching for a term
    Given I am on the "home" page
    Given I am logged in as "searching_user"
    Given there are categories created
    Given a user has listed the following items
      | title          | description  | categories    | price |
      | Baseball       | Baseball     | Electronics   | 1.00  |
      | Skis           | Skis         | Toys & Games  | 10.00  |
      | Snowboard      | Snowboard    | Books         | 100.00  |
      | Football       | Football     | Books         | 1000.00  |
      | Baseball 2     | Baseball 2   | Clothing      | 10000.00  |


  Scenario: Seeing the search results
    When I search for "Baseball"
    Then I should see the item "Baseball"
    Then I should not see the "Skis" item
    And I should not see the "Snowboard" item
    And I should not see the "Football" item

  Scenario: Searching categories from the home page
    Given I am on the "home" page
    Given I click on the "Books" link
    And I should see the "Snowboard" item
    And I should see the "Football" item
    And I should not see the "Baseball" item
    Then I should not see the "Skis" item

  Scenario: Searching with empty string
    Given I search for ""
    Then I should see the "Baseball" item
    And I should see the "Skis" item
    And I should see the "Snowboard" item
    And I should see the "Football" item

  Scenario: Searching with a term that does not match any items
    Given I search for "Pizza"
    Then I should not see the "Baseball" item
    And I should not see the "Skis" item
    And I should not see the "Snowboard" item
    And I should not see the "Football" item

  Scenario: Searching with a term that matches multiple items
    Given I search for "Baseball"
    Then I should see the following items
      | title          | category    | price    |
      | Baseball       | Electronics | $1.00    |
      | Baseball 2     | Clothing    | $10,000.00 |

  Scenario: Filtering options on the search page
    Given I search for "Baseball"
    Then I should see the correct filters

  Scenario: Filtering by category
    Given I search for "Baseball"
    Then I should see the "Baseball 2" item
    And I check the "Electronics" category filter
    And I click the "Filter" button
    Then I should see the "Baseball" item
    And I should not see the "Baseball 2" item

  Scenario: Filtering by category and my bookmarks
    Given I bookmark the "Baseball" item
    Given I unbookmark the "Baseball 2" item
    Given I search for "Baseball"
    And I check the "Electronics" category filter
    And I check the "Clothing" category filter
    Then I should see the "Baseball" item
    And I should see the "Baseball 2" item
    And I check the my bookmarks only filter
    And I click the "Filter" button
    Then I should see the "Baseball" item
    And I should not see the "Baseball 2" item

  Scenario: Filtering by price
    Given I search for "Baseball"
    Then I should see the "Baseball" item
    Then I should see the "Baseball 2" item
    And I fill in "min_price" with "100"
    And I fill in "max_price" with "1000"
    And I click the "Filter" button
    Then I should not see the "Baseball 2" item
    And I should see the "Baseball" item

  Scenario: Filtering by price, categories, and my bookmarks
    Given I search for ""
    Then I should see the "Baseball" item
    Then I should see the "Baseball 2" item
    Then I should see the "Skis" item
    Then I should see the "Snowboard" item
    Then I should see the "Football" item
    And I fill in "min_price" with "10"
    And I fill in "max_price" with "1000"
    And I click the "Filter" button
    Then I should see the "Snowboard" item
    Then I should see the "Football" item
    Then I should see the "Skis" item
    Given I bookmark the "Snowboard" item
    Given I bookmark the "Skis" item
    Given I unbookmark the "Football" item
    And I check the my bookmarks only filter
    Then I click the "Filter" button
    Then I should not see the "Football" item
    Then I should see the "Snowboard" item
    Then I should see the "Skis" item
    And I check the "Books" category filter
    And I click the "Filter" button
    Then I should not see the "Skis" item
    Then I should see the "Snowboard" item


