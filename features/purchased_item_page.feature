Feature: Item Page

  Background:
    Given I am logged in as "testuser"
    And I have valid payment methods and addresses
    Given I am on the "search" page
    Given there are categories created
    Given I have the following items for sale:
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |

    Given I have purchased the "Baseball" item
    Given I search for "Baseball"
    When I click on the item link

  Scenario: Accessing the Item Page
    Then I should see the purchased item page:
      | user       | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | testuser   | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |

