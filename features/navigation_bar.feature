Feature: Use a navigation bar at the top of the screen to navigate around the website

  Scenario:  Use the navigation bar
    Given I am logged in as a regular user
    Given I am on the "home" page
    Then I should see user-specific content

  Scenario: Use the navigation bar from the profile page
    Given I am logged in as a regular user
    Given I am on the "profile" page
    Then I should see user-specific content

  Scenario: Should not see the navigation bar when not logged in
    Given I am on the "home" page
    Then I should not see the navigation bar

