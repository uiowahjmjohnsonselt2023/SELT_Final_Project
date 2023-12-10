Feature: Edit Profile Screen Functionality

  Background:
    Given I am logged in as "testuser"
    Given I am on the "profile" page

  Scenario: Adding a Payment Method
    Then I should not see any payment method
    And I am on the "edit profile" page
    When I fill in "Card number" with "1234567890123456"
    When I fill in expiration date
    Then I click the "Add Payment Method" button
    And I am on the "profile" page
    Then I should see "****-****-****-3456"

  Scenario: Adding a Shipping Address
    Then I should not have the address "1234 Main St"
    And I am on the "edit profile" page
    When I fill in "Address" with "1234 Main St"
    When I fill in "City" with "San Francisco"
    When I select "California" from "state"
    When I fill in "Postal Code" with "94105"
    Then I click the "Add Address" button
    And I am on the "profile" page
    Then I should see "1234 Main St"

  Scenario: Deleting a shipping address
    Then I should not have the address "1234 Main St"
    And I am on the "edit profile" page
    When I fill in "Address" with "1234 Main St"
    When I fill in "City" with "San Francisco"
    When I select "California" from "state"
    When I fill in "Postal Code" with "94105"
    Then I click the "Add Address" button
    And I am on the "profile" page
    Then I should see "1234 Main St"
    When I am on the "edit profile" page
    When I select "1234 Main St, San Francisco, California" from "address-select"
    Then I click the "Delete Address" button
    And I am on the "profile" page
    Then I should not have the address "1234 Main St"

  Scenario: Deleting a Payment Method
    Then I should not see any payment method
    And I am on the "edit profile" page
    When I fill in "Card number" with "1234567890123456"
    When I fill in expiration date
    Then I click the "Add Payment Method" button
    And I am on the "profile" page
    Then I should see "****-****-****-3456"
    When I am on the "edit profile" page
    When I select "Card ending in 3456" from "payment-method-select"
    Then I click the "Delete Payment Method" button
    And I am on the "profile" page
    Then I should not see any payment method









