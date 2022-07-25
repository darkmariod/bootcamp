# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create!({
  email: "john.doe@example.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  username: "johndoe"
})

user2 = User.create!({
  email: "jane.doe@example.com",
  password: "password",
  password_confirmation: "password",
  username: "janedoe"
})

community1 = Community.create!(
  name: "webdesign",
  title: "Web Design",
  description: "All things web design",
  sidebar: "All things web design",
  user_id: user.id
)

community2 = Community.create!(
  name: "rails",
  title: "Rails",
  description: "All things Ruby on Rails",
  sidebar: "All things Ruby on Rails",
  user_id: user.id
)

community3 = Community.create!(
  name: "ruby",
  title: "Ruby",
  description: "All things ruby",
  sidebar: "All things ruby",
  user_id: user.id
)

20.times do
  submission = Submission.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph,
    community: [community1, community2, community3].sample,
    user: [user, user2].sample
  )
  puts "Submission #{submission.id} created"
end
