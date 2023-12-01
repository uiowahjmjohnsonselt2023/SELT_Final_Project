Given(/^I have purchased the "([^"]*)" item$/) do |item_title|
  # Make sure the item exists in the database
  item = Item.find_by!(title: item_title)

  # Assuming @user is already defined and represents the currently logged-in user
  # Also, assuming purchase_item is a method defined in your user model that handles purchasing logic
  @user.purchase_item(item, @user.addresses.first.id, @user.payment_methods.first.id)
end


And(/^I have valid payment methods and addresses$/) do
  @user.addresses.create!(shipping_address_1: "19 E Burlington St", shipping_address_2: "Apt 4", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
  @user.payment_methods.create!(encrypted_card_number: "encrypted_card_number", expiration_date: Date.new(2025, 01, 01).to_s(:long))
end

Then(/^I should see the purchased item page:$/) do |table|
  table.hashes.each do |item|
    expect(page).to have_content(item['user'])
    expect(page).to have_content(item['title'])
    expect(page).to have_content(item['description'])
    expect(page).to have_content(item['price'])
  end

  expect(page).to have_content("Purchased on")
end
