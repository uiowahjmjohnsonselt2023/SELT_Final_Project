Feature: Home Screen Functionality

  Scenario: Viewing my for sale items on the home page
    Given I am logged in as a regular user
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
    Given I am logged in as a regular user
    Given there are categories created
    Given a user has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    And I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Baseball      |
      | Skis          |

  Scenario: Not viewing user items on the home page when not logged in
    Given I am on the "home" page
    Given there are categories created
    Given a user has listed the following items
      | title          | description  | categories  | price |
      | Baseball       | Baseball     | Electronics | 1.00  |
      | Skis           | Skis         | Books       | 1.00  |
    And I am on the "home" page
    Then I should not see the following suggested items
      | title         |
      | Baseball      |
      | Skis          |
