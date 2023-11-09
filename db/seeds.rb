# db/seeds.rb

# Clear the database of existing data.
User.delete_all
Item.delete_all
Address.delete_all
PaymentMethod.delete_all
Image.delete_all
Category.delete_all

# Create categories
categories = ["Electronics", "Books", "Clothing", "Home & Garden", "Toys & Games"].map do |category_name|
  Category.create!(name: category_name)
end

# Create a main sample user.
main_user = User.create!(username: "mainuser", password: "password", password_confirmation: "password", email: "mainuser@example.com", phone_number: "1234567890")
main_user.addresses.create!(shipping_address_1: "123 Main St", shipping_address_2: "Apt 1", city: "Anytown", state: "State", country: "Country", postal_code: "12345")

# Generate additional users.
9.times do |n|
  username  = "user#{n+1}"
  password = "password"
  user = User.create!(username: username, password: password, password_confirmation: password, email: "#{username}@example.com", phone_number: "123456789#{n}")

  # Each user will have one address and one payment method.
  user.addresses.create!(shipping_address_1: "123 Main St", shipping_address_2: "Apt 1", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
  user.payment_methods.create!(encrypted_card_number: "encrypted_card_number", encrypted_card_number_iv: "encrypted_card_number_iv", expiration_date: Date.today + 1.year)

  # Each user will have one item for sale with one image and some categories.
  item = user.items.create!(title: "Item #{n+1}", description: "Description for item #{n+1}")
  item.images.create!(data: "image_data")
  item.categories << categories.sample(2) # Randomly assign two categories to each item
end

# Create items for the main user.
5.times do |n|
  title  = "Main Item #{n+1}"
  description = "Main description #{n+1}"
  item = main_user.items.create!(title: title, description: description)
  item.images.create!(data: "main_image_data")
  item.categories << categories.sample(2) # Randomly assign two categories to each item
end
