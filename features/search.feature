Feature: Seeing the search results

  Background: Searching for a term
    Given I am on the "home" page
    Given I am logged in as "searching_user"
    Given there are categories created
    Given "test_search_user" has listed the following items
      | title     | description | categories   | price    | width    | length   | height   | dimension_units | weight   | weight_units | condition |
      | Baseball  | Baseball    | Electronics  | 1.00     | 1.00     | 1.00     | 1.00     | ft              | 1.00     | lbs          | 0         |
      | Skis      | Skis        | Toys & Games | 10.00    | 10.00    | 10.00    | 10.00    | ft              | 10.00    | lbs          | 0         |
      | Snowboard | Snowboard   | Books        | 100.00   | 100.00   | 100.00   | 100.00   | ft              | 100.00   | lbs          | 0         |
      | Football  | Football    | Books        | 1000.00  | 1000.00  | 1000.00  | 1000.00  | ft              | 1000.00  | lbs          | 0         |
      | Baseball2 | Baseball 2  | Clothing     | 10000.00 | 10000.00 | 10000.00 | 10000.00 | ft              | 10000.00 | lbs          | 0         |

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
      | title     | category    | price      | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball  | Electronics | $1.00      | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Baseball2 | Clothing    | $10,000.00 | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |


  Scenario: Filtering by category
    Given I search for "Baseball"
    Then I should see the "Baseball2" item
    And I check the "Electronics" category filter
    And I click the filter button
    Then I should see the "Baseball" item

  Scenario: Filtering by category and my bookmarks
    Given I bookmark the "Baseball" item
    Given I unbookmark the "Baseball2" item
    Given I search for "Baseball"
    And I check the "Electronics" category filter
    And I check the "Clothing" category filter
    Then I should see the "Baseball" item
    And I should see the "Baseball2" item
    And I check the my bookmarks only filter
    And I click the filter button
    Then I should see the "Baseball" item

  Scenario: Filtering by price
    Given I search for "Baseball"
    Then I should see the "Baseball" item
    Then I should see the "Baseball2" item
    And I fill in the filter "min_price" with "1"
    And I fill in the filter "min_price" with "1000"
    And I click the filter button
    And I should see the "Baseball" item

  Scenario: Filtering by seller
    Given "test_search_user2" has listed the following items
      | title       | description | categories  | price    | width | length | height | dimension_units | weight | weight_units | condition |
      | Chevy Truck | Big Truck   | Electronics | 10000.00 | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    Given "test_search_user3" has listed the following items
      | title      | description  | categories   | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Ford Truck | Little Truck | Toys & Games | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    Given I search for "Truck"
    Then I should see the "Chevy Truck" item
    Then I should see the "Ford Truck" item
    And I fill in the filter "seller" with "test_search_user2"
    And I click the filter button
    And I should see the "Chevy Truck" item

  Scenario: Filtering by price, categories, and my bookmarks
    Given I search for ""
    Then I should see the "Baseball" item
    Then I should see the "Baseball2" item
    Then I should see the "Skis" item
    Then I should see the "Snowboard" item
    Then I should see the "Football" item
    And I fill in the filter "min_price" with "10"
    And I fill in the filter "max_price" with "1000"
    And I click the filter button
    Then I should see the "Snowboard" item
    Then I should see the "Football" item
    Then I should see the "Skis" item
    Given I bookmark the "Snowboard" item
    Given I bookmark the "Skis" item
    Given I unbookmark the "Football" item
    And I check the my bookmarks only filter
    Then I click the filter button
    Then I should see the "Snowboard" item
    And I check the "Books" category filter
    And I click the filter button
    Then I should see the "Snowboard" item


