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


total_items = SEEDS_ITEMS.length

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

  # Create one item for each user
  insert_item(user, i)

  # [0, total_items / 3, 2 * total_items / 3].each do |offset|
  #   item_index = (i + offset) % total_items
  #   insert_item(user, item_index)
  # end
end

# Give the rest of the items to random users
(total_items - SEEDS_USERS.length).times do |i|
  user = User.all.sample
  insert_item(user, i+SEEDS_USERS.length)
end
