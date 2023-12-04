Feature: Editing an existing listed item
  Background:
    Given I am logged in as "edit_user"
    Given there are categories created
    Given I have the following items for sale:
      | title       | description  | categories    | price    |
      | Chevy Truck | Big Truck    | Electronics   | 10000.00 |

  Scenario: Editing an item
    Given I search for my items
    Given I click on the item link
    And I click the "Edit Item" button
    And I edit the item as the following:
      | title          | description  | categories    | price    |
      | Chevy Truck    | Small Truck  | Electronics   | 10.00    |
    Then I should see the item page for "Chevy Truck"

Scenario: Deleting a Listing
  Given I search for my items
  Given I click on the item link
  And I click the "Delete Item" button
  Then I search for my items
  Then I should not see the "Chevy Truck" item



