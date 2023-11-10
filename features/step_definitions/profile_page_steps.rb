
Then(/^I should be redirected to the profile page$/) do
  expect(current_path).to eq profile_path
end

Then(/^I should see the profile page$/) do
  expect(page).to have_content('Profile')
  expect(current_path).to eq(profile_path)
end

Then(/^I should see the profile page with the user's information$/) do
  expect(page).to have_content(user.username)
  expect(page).to have_content(user.email)
  expect(page).to have_content(user.phone_number)
end
