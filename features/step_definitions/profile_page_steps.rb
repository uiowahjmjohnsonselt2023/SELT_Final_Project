
Then(/^I should be redirected to the profile page$/) do
  expect(current_path).to eq profile_path
end

Then(/^I should see the profile page$/) do
  expect(page).to have_content('Profile')
  expect(current_path).to eq(profile_path)
end

Then(/^I should see the profile page with the user's information$/) do
  expect(page).to have_content(@user.username)
  expect(page).to have_content(@user.email)
  expect(page).to have_content(@user.phone_number)
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
    encrypted_card_number: "**** **** **** 1234",
    encrypted_card_number_iv: "encrypted_card_number_iv",
    expiration_date: 3.years.from_now
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
    expect(page).to have_content(payment_method.encrypted_card_number)
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



