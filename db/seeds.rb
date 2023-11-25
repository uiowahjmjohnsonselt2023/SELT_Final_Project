# db/seeds.rb

# Clear the database of existing data.
Bookmark.delete_all
Image.delete_all
PaymentMethod.delete_all
Address.delete_all
Category.delete_all
Item.delete_all
User.delete_all

# Create categories
["Electronics", "Collectibles", "Books", "Clothing", "Home & Garden", "Movies, Music & Games", "Sports & Outdoors", "Toys, Kids & Baby"].map do |category_name|
  Category.create!(name: category_name)
end

# Create sample users
usernames = ["Bud Mann", "Claude Riddle", "Jennie Casey", "Betsy Ware",
             "Todd Conrad", "Lou Tyler", "Jody Hahn", "Kim Jarvis"]

items = [
  { title: "Mystery Novel", description: "Gripping mystery novel by a best-selling author.", price: 15.00, category: "Books", image: "book.jpg" },
  { title: "Wireless Headphones", description: "High-quality, noise-cancelling wireless headphones.", price: 120.00, category: "Electronics", image: "headphones.jpg" },
  { title: "Running Shoes", description: "Lightweight and comfortable running shoes, size 8.", price: 80.00, category: "Clothing", image: "shoes.jpg" },
  { title: "Board Game", description: "Fun family board game, suitable for all ages.", price: 30.00, category: "Movies, Music & Games", image: "board_game.jpg" },
  { title: "Comic Book", description: "Limited edition superhero comic book, mint condition.", price: 40.00, category: "Collectibles", image: "comic_book.jpg" },
  { title: "Gardening Set", description: "Complete gardening tool set with gloves and shears.", price: 35.00, category: "Home & Garden", image: "gardening_tools.jpg" },
  { title: "Decorative Vase", description: "Elegant ceramic vase, perfect for home decoration.", price: 50.00, category: "Home & Garden", image: "vase.jpg" },
  { title: "Teddy Bear", description: "Soft and cuddly teddy bear for kids.", price: 20.00, category: "Toys, Kids & Baby", image: "teddy_bear.jpg" },
  { title: "Camping Tent", description: "Four-person camping tent, easy to set up.", price: 150.00, category: "Sports & Outdoors", image: "tent.jpg" },
  { title: "Smart Watch", description: "Latest model smart watch with fitness tracking features.", price: 250.00, category: "Electronics", image: "smart_watch.jpg" },
  { title: "Vintage Coin", description: "Rare vintage coin from 1920, in excellent condition.", price: 75.00, category: "Collectibles", image: "coin.jpg" },
  { title: "Cookbook", description: "A cookbook with delicious recipes from around the world.", price: 20.00, category: "Books", image: "cookbook.jpg" },
  { title: "Leather Jacket", description: "Stylish black leather jacket, size medium.", price: 100.00, category: "Clothing", image: "jacket.jpg" },
  { title: "Movie Memorabilia", description: "Collectible memorabilia from a popular movie, including a replica prop.", price: 60.00, category: "Movies, Music & Games", image: "movie_collectible.jpg" },
  { title: "Football", description: "Official size football, great for outdoor play.", price: 25.00, category: "Sports & Outdoors", image: "football.jpg" },
  { title: "Building Blocks", description: "Colorful building blocks set, safe for toddlers.", price: 30.00, category: "Toys, Kids & Baby", image: "blocks.jpg" }
]

usernames.each_with_index do |name, i|
  user = User.create!(username: name.downcase.gsub(" ", ""), email: name.downcase.gsub(" ", "") + "@gmail.com", phone_number: "123456789#{i}")
  if i == 0
    address = "123 1st St"
  elsif i == 1
    address = "123 2nd St"
  elsif i == 2
    address = "123 3rd St"
  else
    address = "123 #{i + 1}th St"
  end

  user.addresses.create!(shipping_address_1: address, shipping_address_2: "Apt #{i + 1}", city: "Anytown", state: "State", country: "Country", postal_code: "12345")
  user.payment_methods.create!(encrypted_card_number: "encrypted_card_number", encrypted_card_number_iv: "encrypted_card_number_iv", expiration_date: Date.new(2025, 01, 01).to_s(:long))

  insert_item = items[i]
  image_data = File.read(Rails.root.join("app/assets/images/#{insert_item[:image]}"), mode: 'rb')
  image_type = insert_item[:image].split(".").last

  item = user.items.create!(title: insert_item[:title], description: insert_item[:description], price: insert_item[:price])
  item.categories << Category.find_by(name: insert_item[:category])
  item.images.create!(data: image_data, image_type: image_type)
end
