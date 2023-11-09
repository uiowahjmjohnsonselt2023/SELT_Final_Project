Feature: Profile Screen Functionality

  Scenario: Viewing my profile page
    Given I am logged in as a regular user
    Given I have the following information
      | first_name | last_name | email             | phone_number | address | city    | state | zip_code |
      | John       | Doe       | john@gmail.com    | 1234567890   | 1234 A  | Boston  | MA    | 12345    |
    Given I am on the "profile" page
    Then I the following information:



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
