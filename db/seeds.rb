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
main_user = User.create!(username: "mainuser", email: "mainuser@example.com", phone_number: "1234567890")
main_user.addresses.create!(shipping_address_1: "123 Main St", shipping_address_2: "Apt 1", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
main_user.addresses.create!(shipping_address_1: "456 Main St", shipping_address_2: "APT 2", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
main_user.payment_methods.create!(encrypted_card_number: "encrypted_card_number", encrypted_card_number_iv: "encrypted_card_number_iv", expiration_date: Date.new(2025,01,01).to_s(:long))

image_file_path = Rails.root.join('app', 'assets', 'images', 'Basketball.jpeg')
image_type, image_data = Image.get_image_data(image_file_path)

# Generate additional users.
9.times do |n|
  username = "user#{n + 1}"
  user = User.create!(username: username, email: "#{username}@example.com", phone_number: "123456789#{n}")
  # update time
  # Each user will have one address and one payment method.
  user.addresses.create!(shipping_address_1: "123 Main St", shipping_address_2: "Apt 1", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
  user.payment_methods.create!(encrypted_card_number: "encrypted_card_number", encrypted_card_number_iv: "encrypted_card_number_iv", expiration_date: Date.new(2025,01,01).to_s(:long))

  # Each user will have one item for sale with one image and some categories.
  item = user.items.create!(title: "Basketball #{n + 1}", description: "A nice basketball in good condition #{n + 1}", price: 10.00)
  item.images.create!(data: image_data, image_type: image_type)
  item.categories << categories.sample(2) # Randomly assign two categories to each item
end

# Create items for the main user.
5.times do |n|
  title = "Main Item #{n + 1}"
  description = "Main description #{n + 1}"
  item = main_user.items.create!(title: title, description: description, price: 10.00)
  item.images.create!(data: image_data, image_type: image_type)
  item.categories << categories.sample(2) # Randomly assign two categories to each item
end
