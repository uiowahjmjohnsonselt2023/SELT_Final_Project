When(/^I click on the Buy Now button$/) do
  # Find the button using its class and click on it
  find_button('Buy Now', class: 'buy-button').click
end

Then(/^I should see the checkout page$/) do |table|
  table.hashes.each do |item|
    expect(page).to have_content(item['title'])
    expect(page).to have_content(item['description'])
    expect(page).to have_content(item['price'])
  end
  expect(page).to have_content('Checkout Now')
end
