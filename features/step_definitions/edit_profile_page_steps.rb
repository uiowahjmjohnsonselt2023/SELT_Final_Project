
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






