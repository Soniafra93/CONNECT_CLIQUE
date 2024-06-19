# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
User.destroy_all

# Delete activities associated with each user
User.all.each do |user|
  user.activities.destroy_all
end

# Create Users manually
# Create user 1
user1 = User.create!(
  first_name: "John",
  last_name: "Doe",
  nickname: "john_doe",
  email: "john@example.com",
  password: "john123456"
)

activity1 = Activity.create!(
  name: "Morning Jogging",
  description: "Morning jogging session at the park",
  address: "60 rue du Cherche Midi, 75006",
  date_1: Date.today + 1.day,
  date_2: Date.today + 3.days,
  date_3: Date.today + 5.days,
  user: user1
)

Vote.create!(
  selected_date: activity1.date_1,
  user: user1,
  activity: activity1
)
puts "Created User #{user1.first_name} with Activity '#{activity1.name}'"

# Create user 2
user2 = User.create!(
  first_name: "Jane",
  last_name: "Smith",
  nickname: "jane_smith",
  email: "jane@example.com",
  password: "jane123456"
)

activity2 = Activity.create!(
  name: "Yoga Class",
  description: "Evening yoga class",
  address: "2 rue de Marseille, 75010",
  date_1: Date.today + 2.days,
  date_2: Date.today + 4.days,
  date_3: Date.today + 6.days,
  user: user2
)

Vote.create!(
  selected_date: activity2.date_1,
  user: user2,
  activity: activity2
)

puts "Created User #{user2.first_name} with Activity '#{activity2.name}'"

# Create user 3
user3 = User.create!(
  first_name: "Michael",
  last_name: "Brown",
  nickname: "michael_brown",
  email: "michael@example.com",
  password: "michael123456"
)

activity3 = Activity.create!(
  name: "Basketball Game",
  description: "Weekend basketball game",
  address: "4 Foscote Mews, London",
  date_1: Date.today + 3.days,
  date_2: Date.today + 5.days,
  date_3: Date.today + 7.days,
  user: user3
)

Vote.create!(
  selected_date: activity3.date_1,
  user: user3,
  activity: activity3
)

puts "Created User #{user3.first_name} with Activity '#{activity3.name}'"

# Create user 4
user4 = User.create!(
  first_name: "Emily",
  last_name: "Davis",
  nickname: "emily_davis",
  email: "emily@example.com",
  password: "emily123456"
)

activity4 = Activity.create!(
  name: "Art Class",
  description: "Art class for beginners",
  address: "Ariel Way Shepherds Bush, London ",
  date_1: Date.today + 4.days,
  date_2: Date.today + 6.days,
  date_3: Date.today + 8.days,
  user: user4
)

Vote.create!(
  selected_date: activity4.date_1,
  user: user4,
  activity: activity4
)

puts "Created User #{user4.first_name} with Activity '#{activity4.name}'"

# Create user 5
user5 = User.create!(
  first_name: "William",
  last_name: "Johnson",
  nickname: "william_johnson",
  email: "william@example.com",
  password: "william123456"
)

activity5 = Activity.create!(
  name: "Movie Night",
  description: "Outdoor movie screening",
  address: "Triangle d'or, 100 Bd Aïn Taoujtate, Casablanca 20100, Maroc",
  date_1: Date.today + 5.days,
  date_2: Date.today + 7.days,
  date_3: Date.today + 9.days,
  user: user5
)

Vote.create!(
  selected_date: activity5.date_1,
  user: user5,
  activity: activity5
)

puts "Created User #{user5.first_name} with Activity '#{activity5.name}'"
