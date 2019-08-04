# This file is for setting up your seeds.
#
# To run seeds execute `amber db seed`

# Example:
# User.create(name: "example", email: "ex@mple.com")
require "faker"

locations = [
  ["Phoenix", "AZ"],
  ["Scottsdale", "AZ"],
  ["Chandler", "AZ"],
  ["Mesa", "AZ"],
  ["Gilbert", "AZ"],
  ["Queen Creek", "AZ"]
]

preferences = [
  ["man", "woman"],
  ["woman", "man"]
]

30.times do |n|
  email = Faker::Internet.email
  name = Faker::Name.name
  location = locations.sample
  preference = preferences.sample
  user = User.create(
    name: name,
    email: email,
    password: "password",
    city: location[0],
    state: location[1],
    gender: preference[0],
    preference: preference[1]
  )

  Image.create(
    user_id: user.id,
    object_url: "https://icon-library.net/images/default-user-icon/default-user-icon-11.jpg"
  )
end

User.all.each do |user|
  distances = user.set_distances
  User.all.each_with_index do |other, idx|
    distances["#{other.id}"] = {
      "location" => other.location,
      "distance" => idx
    }
  end

  user.update(distances: distances.to_json)
end
