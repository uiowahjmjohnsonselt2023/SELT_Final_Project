# db/seeds.rb

# Clear the database of existing data.
User.delete_all
Item.delete_all
Address.delete_all
PaymentMethod.delete_all
Image.delete_all

# Create a main sample user.
main_user = User.create!(username: "mainuser", password: "password", password_confirmation: "password", email: "mainuser@example.com", phone_number: "1234567890")

# Generate additional users.
9.times do |n|
  username  = "user#{n+1}"
  password = "password"
  user = User.create!(username: username, password: password, password_confirmation: password, email: "#{username}@example.com", phone_number: "123456789#{n}")
  # update time
  # Each user will have one address and one payment method.
  user.addresses.create(shipping_address_1: "123 Main St", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
  user.payment_methods.create(encrypted_card_number: "encrypted_card_number", encrypted_card_number_iv: "encrypted_card_number_iv", expiration_date: Date.today + 1.year)

  # Each user will have one item for sale with one image.
  item = user.items.create!(title: "Item #{n+1}", description: "Description for item #{n+1}", tags: "tag1,tag2")
  item.images.create!(data: "image_data")
end

# Create items for the main user.
5.times do |n|
  title  = "Main Item #{n+1}"
  description = "Main description #{n+1}"
  item = main_user.items.create!(title: title, description: description, tags: "tag1,tag2")
  item.images.create!(data: "main_image_data")
end
