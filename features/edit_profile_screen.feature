Feature: Edit Profile Screen Functionality

  Scenario: Viewing my profile page
    Given I am logged in as "testuser"
    And I have added one payment method to my profile
    When I am on the "profile" page
    Then I should see the added payment methods






