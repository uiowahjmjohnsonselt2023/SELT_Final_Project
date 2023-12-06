
Then(/^I should see edit card$/) do
  expect(page).to have_content("Card number")
  expect(page).to have_button("Add Payment Method")
end








