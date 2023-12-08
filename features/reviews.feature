Feature: Reviewing an item
  Background:
    Given I am logged in as "review_test_user"
    And I have valid payment methods and addresses
    Given there are categories created
    Given "mainuser" has listed the following items
      | title    | description | categories  | price | width | length | height | dimension_units | weight | weight_units | condition |
      | Baseball | Baseball    | Electronics | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
      | Skis     | Skis        | Books       | 1.00  | 1.00  | 1.00   | 1.00   | ft              | 1.00   | lbs          | 0         |
    Given I have purchased the "Baseball" item

  Scenario: Seeing the review form
    And I search for "Baseball"
    And I click on the "Baseball" link
    Then I should see the review form
    Then I search for "Skis"
    Then I click on the "Skis" link
    Then I should not see the review form

  Scenario: Submitting a review
    And I search for "Baseball"
    And I click on the "Baseball" link
    Then I should see the review form
    And I fill in "Rating (1 to 5)" with "5"
    And I fill in "Review Title" with "Great Experience"
    And I fill in "Your Review" with "I had a great experience with this seller"
    And I click the "Submit Review" button
    Then I am logged in as "review_test_user2"
    And I search for "Baseball"
    And I click on the "Baseball" link
    Then I should see "Great Experience"
    Then I should see "I had a great experience with this seller"
    Then I should see "★ ★ ★ ★ ★"

  Scenario: Seeing a review on the profile page
    Given I am logged in as "review_test_user"
    And I search for "Baseball"
    And I click on the "Baseball" link
    Then I should see the review form
    And I fill in "Rating (1 to 5)" with "5"
    And I fill in "Review Title" with "Great Experience"
    And I fill in "Your Review" with "I had a great experience with this seller"
    And I click the "Submit Review" button
    Then I am logged in as "review_test_user2"
    And I visit the profile page for "mainuser"
    Then I should see "Great Experience"
    Then I should see "I had a great experience with this seller"
    Then I should see "★ ★ ★ ★ ★"
    And I visit the profile page for "review_test_user"
    Then I should not see "Great Experience"
    Then I should not see "I had a great experience with this seller"
    Then I should not see "★ ★ ★ ★ ★"

  Scenario: Deleting a Review
     Given I am logged in as "review_test_user"
      And I search for "Baseball"
      And I click on the "Baseball" link
      Then I should see the review form
      And I fill in "Rating (1 to 5)" with "5"
      And I fill in "Review Title" with "Great Experience"
      And I fill in "Your Review" with "I had a great experience with this seller"
      And I click the "Submit Review" button
      Then I search for "Baseball"
      Then I click on the "Baseball" link
      Then I should see "Great Experience"
      Then I should see "I had a great experience with this seller"
      Then I should see "★ ★ ★ ★ ★"
      And I click the "Delete" button
      Then I should not see "Great Experience"
      Then I should not see "I had a great experience with this seller"
      Then I should not see "★ ★ ★ ★ ★"
      And I visit the profile page for "mainuser"
      Then I should not see "Great Experience"
      Then I should not see "I had a great experience with this seller"
      Then I should not see "★ ★ ★ ★ ★"

    Scenario: Not being able to add a review twice for one item
      Given I am logged in as "review_test_user"
      And I search for "Baseball"
      And I click on the "Baseball" link
      Then I should see the review form
      And I fill in "Rating (1 to 5)" with "5"
      And I fill in "Review Title" with "Great Experience"
      And I fill in "Your Review" with "I had a great experience with this seller"
      And I click the "Submit Review" button
      Then I should see "Great Experience"
      Then I should see "I had a great experience with this seller"
      Then I should see "★ ★ ★ ★ ★"
      And I search for "Baseball"
      And I click on the "Baseball" link
      Then I should not see the review form
      And I visit the profile page for "mainuser"
      Then I should see "Great Experience"
      Then I should see "I had a great experience with this seller"
      Then I should see "★ ★ ★ ★ ★"
      And I visit the profile page for "review_test_user"
      Then I should not see "Great Experience"
      Then I should not see "I had a great experience with this seller"
      Then I should not see "★ ★ ★ ★ ★"



