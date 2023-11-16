When(/^I click on the Buy Now button$/) do
  # Find the button using its class and click on it
  find_button('Buy Now', class: 'buy-button').click
end

Then("I should be on the checkout page") do
  expect(page).to have_content('Checkout')
  expect(page).to have_content('Purchasing')
  expect(page)
  # Add more specific checks as needed, e.g., check for item details
end


Then("I should see the correct content on the checkout page:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  item_details = table.hashes.first # This converts the table to a hash

  expect(page).to have_content(item_details['title'])
  expect(page).to have_content(item_details['description'])
  expect(page).to have_content(item_details['categories'])
  expect(page).to have_content(item_details['price'])
end
