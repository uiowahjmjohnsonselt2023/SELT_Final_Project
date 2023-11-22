Feature: Profile Screen Functionality

  Scenario: Viewing my profile page
    Given I am logged in as "testuser"
    Given I am on the "profile" page
    Then I should see the profile page

  Scenario: Viewing profile information
  Given I am logged in as "testuser"
  Given I am on the "profile" page
  Then I should see the profile page with the user's information

  Scenario: Viewing addresses on profile page
    Given I am logged in as "testuser"
    And I have added an address to my profile
    When I am on the "profile" page
    Then I should see the added addresses

  Scenario: Viewing payment methods on profile page
    Given I am logged in as "testuser"
    And I have added a payment method to my profile
    When I am on the "profile" page
    Then I should see the added payment methods

  Scenario: Editing my profile information
    Given I am logged in as "testuser"
    And I am on the "profile" page
    When I click the "Edit" button
    Then I should be redirected to the edit profile page

  Scenario: Pressing My Items for Sale button
    Given I am logged in as "testuser"
    And I am on the "profile" page
    When I click the "My Items for Sale" button
    Then I should be redirected to the my items for sale page

  Scenario: Pressing My Purchases button
    Given I am logged in as "testuser"
    And I am on the "profile" page
    When I click the "My Purchases" button
    Then I should be redirected to the my purchases page

  Scenario: Pressing My Purchases button
    Given I am logged in as "testuser"
    And I am on the "profile" page
    When I click the "Contact Company" button
    Then I should be redirected to the FAQ page




