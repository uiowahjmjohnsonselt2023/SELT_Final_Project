# db/seeds.rb

# Create a main sample user.
User.create!(username: "mainuser", password: "password", password_confirmation: "password")
User.create!(username: "cole", password: "cole", password_confirmation: "cole")

# Generate additional users.
10.times do |n|
  username  = "user#{n+1}"
  password = "password"
  User.create!(username: username, password: password, password_confirmation: password)
end
