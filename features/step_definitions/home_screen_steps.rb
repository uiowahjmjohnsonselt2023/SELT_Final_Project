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


Then('a user has listed the following items') do |table|
  # make a new user
  user = User.create!(
    username: 'testuser2',
    password: 'password',
    password_confirmation: 'password',
    email: 'test2_email@test.com',
    phone_number: '1234567891'
  )

  items = table.hashes # This will convert the table to an array of hashes

  items.each do |item|
    user_item = user.items.create!(title: item["title"], description: item["description"], price: item["price"])
    category = Category.find_by(name: item["categories"])
    user_item.categories << category
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
  user = User.find_by(username: 'testuser')

  items.each do |item|
    user_item = user.items.create!(title: item["title"], description: item["description"], price: item["price"])
    category = Category.find_by(name: item["categories"])
    user_item.categories << category
  end
end
