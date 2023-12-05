Feature: Edit Profile Screen Functionality

  Scenario: Viewing my profile page
    Given I am logged in as "testuser"
    Given I am on the "profile" page
    And I have added a payment method to my profile
    Then I should see the added payment methods






