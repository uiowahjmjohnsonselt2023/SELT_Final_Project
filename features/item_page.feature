Feature: Accessing the Item Page

  Scenario: User navigates to the Item Page
    Given I am on the home page
    When I navigate to the Item Page
    Then I should see the Item Title
