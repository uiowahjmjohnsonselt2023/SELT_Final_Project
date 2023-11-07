# db/seeds.rb

# Clear the database of existing data.
User.delete_all
Item.delete_all

# Create a main sample user.
User.create!(username: "mainuser", password: "password", password_confirmation: "password")
cole = User.create!(username: "cole", password: "cole", password_confirmation: "cole")

# Generate additional users.
10.times do |n|
  username  = "user#{n+1}"
  password = "password"
  User.create!(username: username, password: password, password_confirmation: password)
end

# Generate  items.
10.times do |n|
  title  = "title#{n+1}"
  description = "description#{n+1}"
  cole.items.create!(title: title, description: description)
end
