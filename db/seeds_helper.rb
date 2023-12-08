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
  "Toys, Kids & Baby"
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
  }
].freeze

