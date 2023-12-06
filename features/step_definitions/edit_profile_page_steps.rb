
Then(/^I should see edit card$/) do
  expect(page).to have_content("Card number")
  expect(page).to have_button("Add Payment Method")
end

Then(/^I should see edit shipping info$/) do
  expect(page).to have_content("Shipping Address 1")
  expect(page).to have_button("Add Address")
end






