
Then(/^I should be redirected to the profile page$/) do
  expect(current_path).to eq profile_path
end

Then(/^I should see the profile page$/) do
  expect(page).to have_content('Profile')
  expect(current_path).to eq(user_path(@user.id))
end

Then(/^I should see the profile page with the user's information$/) do
  expect(page).to have_content(@user.username)
  expect(page).to have_content(@user.email)
end

Given(/^I have added an address to my profile$/) do
  @user.addresses.create!(
    shipping_address_1: "123 Main St",
    shipping_address_2: "Apt 1",
    city: "Anytown",
    state: "State",
    country: "Country",
    postal_code: "12345"
  )
end

Given(/^I have added a payment method to my profile$/) do
  @user.payment_methods.create!(
    card_number: "1234123412341234",
    expiration_date: "05/2025"
  )
end

Then(/^I should see the added addresses$/) do
  @user.addresses.each do |address|
    expect(page).to have_content(address.shipping_address_1)
    expect(page).to have_content(address.city)
    # Add checks for the rest of the address fields
  end
end

Then(/^I should see the added payment methods$/) do
  @user.payment_methods.each do |payment_method|
    hidden_card_number = "****-****-****-#{payment_method.last_four_digits}"
    expect(page).to have_content(hidden_card_number)
    # Add checks for the rest of the payment method fields
  end
end

When(/^I click the "([^"]*)" button$/) do |button_text|
  click_button(button_text)
end

Then(/^I should be redirected to the edit profile page$/) do
  expect(current_path).to eq edit_user_path(@user)
end

Then(/^I should be redirected to the my items for sale page$/) do
  expect(current_path).to eq search_path() # TODO: Update this to the correct path
end

Then(/^I should be redirected to the my purchases page$/) do
  expect(current_path).to eq search_path() # TODO: Update this to the correct path
end

Then(/^I should be redirected to the FAQ page$/) do
  expect(current_path).to eq search_path() # TODO: Update this to the correct path
end



