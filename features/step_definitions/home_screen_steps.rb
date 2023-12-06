# features/step_definitions/general_steps.rb

Then('I should see the following suggested items:') do |table|
  # Here you would check that the items appear on the page
  suggested_items = table.hashes # This will convert the table to an array of hashes

  suggested_items.each do |item|
    expect(page).to have_content(item['title'])
  end
end

Given('there are categories created') do
  ["Electronics", "Books", "Clothing", "Home & Garden", "Toys & Games"].map do |category_name|
    Category.create!(name: category_name)
  end
end


Then(/^"(.*?)" has listed the following items$/) do |username, table|
  # make a new user
  auth = {
    'provider' => 'google_oauth2',
    'uid' => '12345',
    'info' => { 'name' => username, 'email' => username + '@test.com' }
  }

  user = User.create_with_omniauth(auth)

  image_file_path = Rails.root.join('app', 'assets', 'images', 'blocks.jpg')
  image_type, image_data = Image.get_image_data(image_file_path)

  items = table.hashes # This will convert the table to an array of hashes

  items.each do |item|
    user_item = user.items.create!(
      title: item["title"], description: item["description"], price: item["price"],
      length: item["length"], width: item["width"], height: item["height"],
      dimension_units: item["dimension_units"], weight: item["weight"],
      weight_units: item["weight_units"], condition: item["condition"]
    )
    category = Category.find_by(name: item["categories"])
    user_item.categories << category
    user_item.images.create!(data: image_data, image_type: image_type)
  end

end

Then('I should see my items for sale') do
  # Ensure that items for sale by the user exist in the database
  Item.create!(title: 'My Item for Sale', user: @user)

  # Now check if the item appears on the page
  expect(page).to have_content('My Item for Sale')
end

Then('I should not see the following suggested items') do |table|

  # Make sure none of the items from the table are listed
  suggested_items = table.hashes # This will convert the table to an array of hashes

  suggested_items.each do |item|
    expect(page).to_not have_content(item['title'])
  end
end

Given('I have the following items for sale:') do |table|
  items = table.hashes # This will convert the table to an array of hashes

  image_file_path = Rails.root.join('app', 'assets', 'images', 'blocks.jpg')
  image_type, image_data = Image.get_image_data(image_file_path)

  items.each do |item|
    user_item = @user.items.create!(
      title: item["title"], description: item["description"], price: item["price"],
      length: item["length"], width: item["width"], height: item["height"],
      dimension_units: item["dimension_units"], weight: item["weight"],
      weight_units: item["weight_units"], condition: item["condition"]
    )
    category = Category.find_by(name: item["categories"])
    user_item.categories << category
    user_item.images.create!(data: image_data, image_type: image_type)
  end
end
