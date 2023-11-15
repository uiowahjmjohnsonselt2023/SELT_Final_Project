Feature: Seeing the search results
  Background: Searching for a term
    Given I am on the "home" page
    Given I am logged in as "searching_user"
    Given there are categories created
    Given a user has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 10.00  |
      | Snowboard      | Snowboard    | Books       | 100.00  |
      | Football       | Football     | Books       | 1000.00  |
      | Baseball 2     | Baseball 2   | Clothing    | 10000.00  |


  Scenario: Seeing the search results
    When I search for "Baseball"
    Then I should see the item "Baseball"
    Then I should not see the "Skis" item
    And I should not see the "Snowboard" item
    And I should not see the "Football" item

  Scenario: Searching categories from the home page
    Given I am on the "home" page
    Given I click on the "Books" link
    Then I should see the "Skis" item
    And I should see the "Snowboard" item
    And I should see the "Football" item
    And I should not see the "Baseball" item

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
