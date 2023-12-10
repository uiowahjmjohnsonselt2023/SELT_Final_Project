# db/seeds_helper.rb

SEEDS_USERS = [
  { name: "Bud Mann" },
  { name: "Claude Riddle" },
  { name: "Jennie Casey" },
  { name: "Betsy Ware" },
  { name: "Todd Conrad" },
  { name: "Lou Tyler" },
  { name: "Jody Hahn" },
  { name: "Kim Jarvis" }
].map.with_index do |user, i|
  address = "#{rand(100..999)} #{['Main St', 'Oak St', 'Pine St', 'Elm St', 'Maple St'].sample}"

  country = if i == 6
              'Mexico'
            elsif i == 7
              'Canada'
            else
              'United States'
            end

  state = if country == 'United States'
            ['California', 'Texas', 'Florida', 'New York', 'Illinois'].sample
          else
            nil
          end

  city = ['Springfield', 'Rivertown', 'Laketown', 'Hillside'].sample
  postal_code = rand(10000..99999)
  card_number = Array.new(16) { rand(0..9) }.join
  expiration_date = "#{rand(1..12).to_s.rjust(2, '0')}/#{rand(Date.today.year..Date.today.year + 5)}"

  user.merge(
    username: user[:name].downcase.gsub(" ", ""),
    email: user[:name].downcase.gsub(" ", "") + "@gmail.com",
    shipping_address_1: address,
    shipping_address_2: rand < 0.5 ? "Apt #{rand(1..10)}" : nil,
    city: city,
    state: state,
    country: country,
    postal_code: postal_code,
    card_number: card_number,
    expiration_date: expiration_date
  )
end


SEEDS_CATEGORIES = [
  "Electronics",
  "Collectibles",
  "Books",
  "Clothing",
  "Home & Garden",
  "Movies, Music & Games",
  "Sports & Outdoors",
  "Toys, Kids & Baby",
  "Arts & Crafts"
]

SEEDS_ITEMS = [
  {
    title: "Mystery Novel",
    description: "Gripping mystery novel by a best-selling author.",
    price: 15.00,
    category: "Books",
    image: "book.jpg",
    length: 8.0, width: 5.0, height: 1.0,
    dimension_units: "in",
    weight: 12.0,
    weight_units: "oz",
    condition: 0
  },
  {
    title: "Wireless Headphones",
    description: "High-quality, noise-cancelling wireless headphones.",
    price: 120.00,
    category: "Electronics",
    image: "headphones.jpg",
    length: 7.0, width: 6.0, height: 2.0,
    dimension_units: "in",
    weight: 8.0,
    weight_units: "oz",
    condition: 0
  },
  {
    title: "Running Shoes",
    description: "Lightweight and comfortable running shoes, size 8.",
    price: 80.00,
    category: "Clothing",
    image: "shoes.jpg",
    length: 11.0, width: 4.0, height: 4.5,
    dimension_units: "in",
    weight: 1.5,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Board Game",
    description: "Fun family board game, suitable for all ages.",
    price: 30.00,
    category: "Movies, Music & Games",
    image: "board_game.jpg",
    length: 12.0, width: 12.0, height: 2.0,
    dimension_units: "in",
    weight: 2.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Comic Book",
    description: "Limited edition superhero comic book, mint condition.",
    price: 40.00,
    category: "Collectibles",
    image: "comic_book.jpg",
    length: 10.0, width: 6.5, height: 0.1,
    dimension_units: "in",
    weight: 5.0,
    weight_units: "oz",
    condition: 0
  },
  {
    title: "Gardening Set",
    description: "Complete gardening tool set with gloves and shears.",
    price: 35.00,
    category: "Home & Garden",
    image: "gardening_tools.jpg",
    length: 24.0, width: 12.0, height: 6.0,
    dimension_units: "in",
    weight: 5.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Decorative Vase",
    description: "Elegant ceramic vase, perfect for home decoration.",
    price: 50.00,
    category: "Home & Garden",
    image: "vase.jpg",
    length: 8.0, width: 8.0, height: 12.0,
    dimension_units: "in",
    weight: 4.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Teddy Bear",
    description: "Soft and cuddly teddy bear for kids.",
    price: 20.00,
    category: "Toys, Kids & Baby",
    image: "teddy_bear.jpg",
    length: 8.0, width: 6.0, height: 10.0,
    dimension_units: "in",
    weight: 10.0,
    weight_units: "oz",
    condition: 0
  },
  {
    title: "Camping Tent",
    description: "Four-person camping tent, easy to set up.",
    price: 150.00,
    category: "Sports & Outdoors",
    image: "tent.jpg",
    length: 96.0, width: 96.0, height: 72.0,
    dimension_units: "in",
    weight: 8.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Smart Watch",
    description: "Latest model smart watch with fitness tracking features.",
    price: 250.00,
    category: "Electronics",
    image: "smart_watch.jpg",
    length: 1.5, width: 1.5, height: 0.4,
    dimension_units: "in",
    weight: 1.2,
    weight_units: "oz",
    condition: 0
  },
  {
    title: "Vintage Coin",
    description: "Rare vintage coin from 1920, in excellent condition.",
    price: 75.00,
    category: "Collectibles",
    image: "coin.jpg",
    length: 1.5, width: 1.5, height: 0.1,
    dimension_units: "in",
    weight: 0.2,
    weight_units: "oz",
    condition: 0
  },
  {
    title: "Cookbook",
    description: "A cookbook with delicious recipes from around the world.",
    price: 20.00,
    category: "Books",
    image: "cookbook.jpg",
    length: 11.0, width: 8.5, height: 1.0,
    dimension_units: "in",
    weight: 2.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Leather Jacket",
    description: "Stylish black leather jacket, size medium.",
    price: 100.00,
    category: "Clothing",
    image: "jacket.jpg",
    length: 24.0, width: 18.0, height: 2.0,
    dimension_units: "in",
    weight: 4.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Movie Memorabilia",
    description: "Collectible memorabilia from a popular movie, including a replica prop.",
    price: 60.00,
    category: "Movies, Music & Games",
    image: "movie_collectible.jpg",
    length: 20.0, width: 14.0, height: 3.0,
    dimension_units: "in",
    weight: 3.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Football",
    description: "Official size football, great for outdoor play.",
    price: 25.00,
    category: "Sports & Outdoors",
    image: "football.jpg",
    length: 12.0, width: 12.0, height: 12.0,
    dimension_units: "in",
    weight: 1.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Building Blocks",
    description: "Colorful building blocks set, safe for toddlers.",
    price: 30.00,
    category: "Toys, Kids & Baby",
    image: "blocks.jpg",
    length: 12.0, width: 8.0, height: 6.0,
    dimension_units: "in",
    weight: 2.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Bluetooth Keyboard",
    description: "Wireless, ergonomic Bluetooth keyboard compatible with multiple devices.",
    price: 50.00,
    category: "Electronics",
    image: "bluetooth_keyboard.jpg",
    length: 14.0, width: 6.0, height: 1.2,
    dimension_units: "in",
    weight: 1.3,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Graphic Novel",
    description: "Award-winning graphic novel, a must-have for collectors.",
    price: 35.00,
    category: ["Books", "Collectibles"],
    image: "graphic_novel.jpg",
    length: 11.0, width: 7.5, height: 0.5,
    dimension_units: "in",
    weight: 1.6,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Vintage Dress",
    description: "Elegant vintage dress from the 1950s, size medium.",
    price: 120.00,
    category: ["Clothing", "Collectibles"],
    image: "vintage_dress.jpg",
    length: 40.0, width: 28.0, height: 0.2,
    dimension_units: "in",
    weight: 1.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Handcrafted Pottery",
    description: "Beautifully handcrafted pottery vase, perfect for home decor.",
    price: 65.00,
    category: ["Home & Garden", "Arts & Crafts"],
    image: "handcrafted_pottery.jpg",
    length: 8.0, width: 8.0, height: 10.0,
    dimension_units: "in",
    weight: 3.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Board Game Collection",
    description: "Set of five classic board games, great for family nights.",
    price: 50.00,
    category: ["Movies, Music & Games", "Toys, Kids & Baby"],
    image: "board_games_collection.jpg",
    length: 20.0, width: 10.0, height: 8.0,
    dimension_units: "in",
    weight: 8.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Basketball Hoop",
    description: "Adjustable outdoor basketball hoop, perfect for sports enthusiasts.",
    price: 150.00,
    category: "Sports & Outdoors",
    image: "basketball_hoop.jpg",
    length: 40.0, width: 30.0, height: 10.0,
    dimension_units: "in",
    weight: 35.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Educational Toy Set",
    description: "Fun and educational toy set for ages 3-6, includes puzzles and games.",
    price: 40.00,
    category: "Toys, Kids & Baby",
    image: "educational_toys.jpg",
    length: 15.0, width: 10.0, height: 4.0,
    dimension_units: "in",
    weight: 3.0,
    weight_units: "lbs",
    condition: 0
  },
  {
    title: "Painting Supplies Kit",
    description: "Complete painting supplies kit, includes brushes, paints, and canvas.",
    price: 75.00,
    category: "Arts & Crafts",
    image: "painting_supplies.jpg",
    length: 22.0, width: 18.0, height: 5.0,
    dimension_units: "in",
    weight: 6.0,
    weight_units: "lbs",
    condition: 0
  },
  # {
  #   title: "Wireless Earbuds",
  #   description: "High-fidelity wireless earbuds with noise cancellation feature.",
  #   price: 100.00,
  #   category: "Electronics",
  #   image: "wireless_earbuds.jpg",
  #   length: 3.0, width: 2.0, height: 1.5,
  #   dimension_units: "in",
  #   weight: 0.2,
  #   weight_units: "oz",
  #   condition: 0
  # },
  # {
  #   title: "Science Fiction Anthology",
  #   description: "Collection of classic science fiction stories by renowned authors.",
  #   price: 25.00,
  #   category: "Books",
  #   image: "sci_fi_anthology.jpg",
  #   length: 9.0, width: 6.0, height: 1.5,
  #   dimension_units: "in",
  #   weight: 1.8,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Retro Gaming Console",
  #   description: "Classic retro gaming console with two controllers and 30 pre-installed games.",
  #   price: 80.00,
  #   category: ["Electronics", "Movies, Music & Games"],
  #   image: "retro_gaming_console.jpg",
  #   length: 10.0, width: 8.0, height: 4.0,
  #   dimension_units: "in",
  #   weight: 2.5,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Fantasy Book Series",
  #   description: "Complete fantasy book series, a thrilling adventure in a magical world.",
  #   price: 60.00,
  #   category: "Books",
  #   image: "fantasy_book_series.jpg",
  #   length: 12.0, width: 8.0, height: 6.0,
  #   dimension_units: "in",
  #   weight: 10.0,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Designer Sunglasses",
  #   description: "Stylish designer sunglasses with UV protection.",
  #   price: 150.00,
  #   category: "Clothing",
  #   image: "designer_sunglasses.jpg",
  #   length: 6.0, width: 3.0, height: 2.0,
  #   dimension_units: "in",
  #   weight: 0.3,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Gourmet Coffee Beans",
  #   description: "Premium gourmet coffee beans, 1 lb bag, freshly roasted.",
  #   price: 25.00,
  #   category: "Home & Garden",
  #   image: "coffee_beans.jpg",
  #   length: 6.0, width: 4.0, height: 3.0,
  #   dimension_units: "in",
  #   weight: 1.0,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Classic Rock Vinyl Records",
  #   description: "Set of 5 classic rock vinyl records, in excellent condition.",
  #   price: 100.00,
  #   category: "Movies, Music & Games",
  #   image: "vinyl_records.jpg",
  #   length: 12.0, width: 12.0, height: 2.5,
  #   dimension_units: "in",
  #   weight: 5.0,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Portable Camping Grill",
  #   description: "Compact and portable camping grill, easy to set up and use.",
  #   price: 70.00,
  #   category: "Sports & Outdoors",
  #   image: "camping_grill.jpg",
  #   length: 20.0, width: 12.0, height: 10.0,
  #   dimension_units: "in",
  #   weight: 8.0,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Plush Animal Toy Set",
  #   description: "Set of 5 assorted plush animal toys, soft and cuddly.",
  #   price: 50.00,
  #   category: "Toys, Kids & Baby",
  #   image: "plush_animals.jpg",
  #   length: 15.0, width: 10.0, height: 8.0,
  #   dimension_units: "in",
  #   weight: 3.0,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "DIY Craft Kit",
  #   description: "DIY craft kit with materials and instructions for making handmade items.",
  #   price: 30.00,
  #   category: "Arts & Crafts",
  #   image: "diy_craft_kit.jpg",
  #   length: 12.0, width: 9.0, height: 3.0,
  #   dimension_units: "in",
  #   weight: 2.0,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Smart Home Assistant",
  #   description: "Voice-activated smart home assistant with various smart features.",
  #   price: 90.00,
  #   category: "Electronics",
  #   image: "smart_home_assistant.jpg",
  #   length: 4.0, width: 4.0, height: 6.0,
  #   dimension_units: "in",
  #   weight: 1.5,
  #   weight_units: "lbs",
  #   condition: 0
  # },
  # {
  #   title: "Historical Biography",
  #   description: "Engaging biography of a famous historical figure, hardcover edition.",
  #   price: 28.00,
  #   category: "Books",
  #   image: "historical_biography.jpg",
  #   length: 9.0, width: 6.0, height: 1.5,
  #   dimension_units: "in",
  #   weight: 1.7,
  #   weight_units: "lbs",
  #   condition: 0
  # }
].freeze

def insert_item(user, i)
  item_to_insert = SEEDS_ITEMS[i]
  image_data = File.read(Rails.root.join("app/assets/images/#{item_to_insert[:image]}"), mode: "rb")
  image_type = item_to_insert[:image].split(".").last

  item = user.items.create!(
    title: item_to_insert[:title],
    description: item_to_insert[:description],
    price: item_to_insert[:price],
    length: item_to_insert[:length],
    width: item_to_insert[:width],
    height: item_to_insert[:height],
    dimension_units: item_to_insert[:dimension_units],
    weight: item_to_insert[:weight],
    weight_units: item_to_insert[:weight_units],
    condition: item_to_insert[:condition]
  )
  item.images.create!(data: image_data, image_type: image_type)
  item.categories << Category.find_by(name: item_to_insert[:category])
end

