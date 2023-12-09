
Then(/^I should see edit card$/) do
  expect(page).to have_content("Card number")
  expect(page).to have_button("Add Payment Method")
end

Then(/^I should see edit shipping info$/) do
  expect(page).to have_content("Shipping Address 1")
  expect(page).to have_button("Add Address")
end

Then(/^I should see delete shipping address$/) do
  expect(page).to have_content("Select Shipping Address to Delete:")
  expect(page).to have_button("Delete Address")
end

Then(/^I should see edit payment method$/) do
  expect(page).to have_content("Select Payment Method to Delete:")
  expect(page).to have_button("Delete Payment Method")
end

Then(/^I should not see any payment method$/) do
  expect(page).to_not have_content("****-****-****")
end

When("I fill in expiration date") do
  select '12', from: 'expiration_month'
  select (Time.now.year+1).to_s, from: 'expiration_year' # Select next year as an example
end



Then(/^I should have the address "([^"]*)"$/) do |arg|
  expect(page).to have_content(arg)
end

Then(/^I should not have the address "([^"]*)"$/) do |arg|
  expect(page).to_not have_content(arg)
end

When(/^I select "([^"]*)" from "([^"]*)"$/) do |arg1, arg2|
  select arg1, from: arg2
end
