Feature: Bookmarking functionality
  Background:
    Given I am logged in as "bookmark_user"
    Given there are categories created
    Given "bookmark_test_user" has listed the following items
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |

  Scenario: Seeing the bookmark button
    Given I am on the "search" page
    Given I search for "Baseball"
    When I click on the "Baseball" link
    Then I should see the bookmark button

  Scenario: Adding a bookmark
    Given I bookmark the "Baseball" item
    And I am on the "profile" page
    And I click on the "Bookmarks" link
    Then I should see the "Baseball" item

  Scenario: Removing a bookmark
    Given I bookmark the "Baseball" item
    And I unbookmark the "Baseball" item
    And I am on the "profile" page
    And I click on the "Bookmarks" link
    Then I should not see the "Baseball" item
