Feature: Editing an existing listed item
  Background:
    Given I am logged in as "Item_editer"
    Given there are categories created
    Given I have the following items for sale:
      | title       | description  | categories    | price    |
      | Chevy Truck | Big Truck    | Electronics   | 10000.00 |

  Scenario: Editing an item
    Given I search for my items
