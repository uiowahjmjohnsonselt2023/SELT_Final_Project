
Then(/^I should be redirected to the home page$/) do
  expect(current_path).to eq root_path
end

Then(/^I should see user-specific content$/) do
  expect(page).to have_content 'Profile'
  expect(page).to have_content 'Sell Item'
  expect(page).to have_content 'Logout'
end

Then(/^I should not see login or signup links$/) do
  expect(page).not_to have_link('Login', href: login_path)
  expect(page).not_to have_link('Sign Up', href: signup_path)
end

Then(/^I should be redirected to the login page if not logged in$/) do
  visit root_path
  expect(current_path).to eq login_path
end

Then(/^I should see a login required message if not logged in$/) do
  visit root_path
  expect(page).to have_content('You must be logged in to access this section')
end

Then("I should not see the navigation bar") do
  expect(page).to have_no_css('navbar-brand'), "Expected not to see the navigation bar, but it was found."
end
