Feature: Home Screen Functionality

  Scenario: Viewing my for sale items on the home page
    Given I am logged in as "testuser"
    Given there are categories created
    Given I have the following items for sale:
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    Given I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Baseball      |
      | Skis          |

  Scenario: Viewing user items on the home page when logged in
    Given I am logged in as "testuser"
    Given there are categories created
    Given "home_test_user" has listed the following items
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    And I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Baseball      |
      | Skis          |

  Scenario: Navigating to items from the home page
    Given I am logged in as "testuser"
    Given there are categories created
    Given "home_test_user" has listed the following items
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    And I am on the "home" page
    When I click on any of the "Baseball" links
    Then I should see the item page:
      | user           | title    | description  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | home_test_user | Baseball | Electronics         | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    Given I am on the "home" page
    When I click on any of the "Skis" links
    Then I should see the item page:
      | user           | title    | description  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | home_test_user | Skis     | Books        | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
