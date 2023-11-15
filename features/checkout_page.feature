Feature: Checkout Screen Rendering

  Background:
    Given I am logged in as "testuser"
    Given I am on the "search" page


  Scenario: Viewing the Checkout Screen
    Given I am on the checkout screen
    Then I should see the checkout screen


