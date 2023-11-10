Feature: Profile Screen Functionality

  Scenario: Viewing my profile page
    Given I am logged in as a regular user
    Given I am on the "profile" page
    Then I should see the profile page

  Scenario: Viewing profile information
  Given I am logged in as a regular user
  Given I am on the "profile" page
  Then I should see the profile page with the user's information

    #Given the user has the following profile information
     # | first_name | last_name | email             | phone_number | address | city    | state | zip_code |
    #  | John       | Doe       | test@gmail.com   | 1234567890   | 1234    | Denver  | CO    | 80202    |
    #Then I should see my profile information
    #  | first_name | last_name | email             | phone_number | address | city    | state | zip_code |
    #  | John       | Doe       | test@gmail.com  | 1234567890   | 1234    | Denver  | CO    | 80202    |


