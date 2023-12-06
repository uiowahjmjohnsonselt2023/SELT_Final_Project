Feature: Reviewing an item
  Background:
    Given I am logged in as "review_test_user"
    Given there are categories created
    Given "mainuser" has listed the following items
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |

