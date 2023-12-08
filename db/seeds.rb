# db/seeds.rb


require_relative 'seeds_helper'

# Clear the database of existing data.
Bookmark.delete_all
Image.delete_all
PaymentMethod.delete_all
Address.delete_all
Category.delete_all
Item.delete_all
User.delete_all

# Create categories
SEEDS_CATEGORIES.map do |category_name|
  Category.create!(name: category_name)
end


SEEDS_USERS.each_with_index do |user_info, i|
  user = User.create!(
    username: user_info[:username],
    email: user_info[:email],
  )

  user.addresses.create!(
    shipping_address_1: user_info[:shipping_address_1],
    shipping_address_2: user_info[:shipping_address_2],
    city: user_info[:city],
    state: user_info[:state],
    country: user_info[:country],
    postal_code: user_info[:postal_code]
  )

  user.payment_methods.create!(
    card_number: user_info[:card_number],
    expiration_date: user_info[:expiration_date]
  )

  insert_item = SEEDS_ITEMS[i]
  image_data = File.read(Rails.root.join("app/assets/images/#{insert_item[:image]}"), mode: "rb")
  image_type = insert_item[:image].split(".").last

  item = user.items.create!(
    title: insert_item[:title],
    description: insert_item[:description],
    price: insert_item[:price],
    length: insert_item[:length],
    width: insert_item[:width],
    height: insert_item[:height],
    dimension_units: insert_item[:dimension_units],
    weight: insert_item[:weight],
    weight_units: insert_item[:weight_units],
    condition: insert_item[:condition]
  )
  item.images.create!(data: image_data, image_type: image_type)
  item.categories << Category.find_by(name: insert_item[:category])
end
