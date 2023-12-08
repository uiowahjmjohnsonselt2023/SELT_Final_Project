Then(/^I should see the review form$/) do
  expect(page).to have_content('Leave a Review for the Seller')
  expect(page).to have_content('Title')
  expect(page).to have_content('Rating')
  expect(page).to have_content('Your Review')
end

Then(/^I should not see the review form$/) do
  expect(page).to_not have_content('Leave a Review for the Seller')
  expect(page).to_not have_content('Title')
  expect(page).to_not have_content('Your Review')
end

Then(/^I should see "([^"]*)"$/) do |arg|
  expect(page).to have_content(arg)
end

And(/^I visit the profile page for "([^"]*)"$/) do |arg|
  user = User.find_by(username: arg)
  visit user_path(user)
end

Then(/^I should not see "([^"]*)"$/) do |arg|
  expect(page).to_not have_content(arg)
end
