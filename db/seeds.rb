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

end

# Give the rest of the items to random users
(total_items - SEEDS_USERS.length).times do |i|
  user = User.all.sample
  insert_item(user, i+SEEDS_USERS.length)
end


# Create a bunch of one item just for creating reviews
number_of_purchases = 10 # Adjust this number as needed

review_contents = [
  "Absolutely loved this mystery novel! The plot twists kept me on the edge of my seat.",
  "An engaging read with well-developed characters. Highly recommend to mystery lovers.",
  "Intriguing storyline, but some parts were predictable. Overall, a decent read.",
  "The narrative was captivating and the suspense was masterfully built up.",
  "Not as thrilling as I expected, but still a good mystery novel with a solid story.",
  "Fantastic writing! The author did a great job of weaving an intricate mystery.",
  "The book started off slow, but it really picked up in the second half. Great ending!",
  "I found the main character to be quite compelling, and the mystery was well thought out.",
  "The plot was a bit convoluted for my taste, though the writing style was superb.",
  "A classic whodunit that kept me guessing until the very end. Would read more from this author."
]

number_of_purchases.times do
  # Select a random user
  user = User.all.sample

  # Simulate the purchase (creation) of the review item by this user

  # Grab an item with the title 'Mystery Novel' that has not been purchased already
  item_to_buy = Item.includes(:purchase).where(title: 'Mystery Novel', purchases: { id: nil }).sample


  while item_to_buy.user == user
    # If the user is the seller, select a different item
    user = User.all.sample
  end

  puts "Buying #{item_to_buy.title} for #{user.username}"

  user.purchase_item(item_to_buy, user.addresses.sample.id, user.payment_methods.sample.id)

  purchase = Purchase.find_by(item_id: item_to_buy.id, user_id: user.id)

  review = Review.new(
    title: "Review for #{item_to_buy.title}",
    rating: rand(1..5), # Random rating between 1 and 5
    content: review_contents.sample,
    reviewer_id: user.id,
    seller_id: item_to_buy.user.id, # Assuming the item has a user association
    item_id: item_to_buy.id
  )

  review.purchase = purchase
  review.save!
  purchase.save!

  # The insert_item method will create a new instance of the item for each user
  insert_item(user, 0)
end

