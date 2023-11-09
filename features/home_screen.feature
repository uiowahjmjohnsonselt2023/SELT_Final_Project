Feature: Home Screen Functionality

  Scenario: Viewing my for sale items on the home page
    Given I am logged in as a regular user
    Given I have the following items for sale:
      | title          | description | tags       |
      | Basketball     | Basketball  | Sports     |
      | Bike           | Bike        | Recreation |
    Given I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Basketball    |
      | Bike          |

  Scenario: Viewing user items on the home page when logged in
    Given I am logged in as a regular user
    Given a user has listed the following items
      | title          | description | tags       |
      | Baseball       | Baseball    | Sports     |
      | Skis           | Skis        | Recreation |
    And I am on the "home" page
    Then I should see the following suggested items:
      | title         |
      | Baseball      |
      | Skis          |

  Scenario: Not viewing user items on the home page when not logged in
    Given I am on the "home" page
    Given a user has listed the following items
      | title          | description | tags       |
      | Baseball       | Baseball    | Sports     |
      | Skis           | Skis        | Recreation |
    And I am on the "home" page
    Then I should not see the following suggested items
      | title         |
      | Basketball    |
      | Bike          |
