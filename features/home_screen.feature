Feature: Home Screen Functionality

  Scenario: Viewing my for sale items on the home page
    Given I am logged in as "testuser"
    Given there are categories created
    Given I have the following items for sale:
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    Given I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Baseball      |
      | Skis          |

  Scenario: Viewing user items on the home page when logged in
    Given I am logged in as "testuser"
    Given there are categories created
    Given "home_test_user" has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    And I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Baseball      |
      | Skis          |

  Scenario: Navigating to items from the home page
    Given I am logged in as "testuser"
    Given there are categories created
    Given "home_test_user" has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | temp         | Electronics | 1.00  |
      | Skis           | temp2        | Books       | 1.00  |
    And I am on the "home" page
    When I click on the "Baseball" link
    Then I should see the item page:
      | user           | title    | description  | price |
      | home_test_user | Baseball | temp         | 1.00  |
    Given I am on the "home" page
    When I click on the "Skis" link
    Then I should see the item page:
      | user           | title    | description  | price |
      | home_test_user | Skis     | temp2        | 1.00  |
