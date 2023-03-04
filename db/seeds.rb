puts "Seeding data"

joe = User.create(first_name: "joe", last_name: "Doe", email: "joe@example.com", password: "myPassoword")

users_list = []

50.times do
    new_user = User.create(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.free_email,
      password_digest: rand(1000..9999)
    )
    users_list << new_user
end

project_list = []
users_list.each do |user|
    rand(1..5).times do
    new_project = Project.create(
        title: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        image_url: Faker::Internet.url,
        # project_status: "completed",
        project_Github_url: Faker::Internet.url,
        user_id: user.id
    )
    project_list << new_project
end
end

users_list.each do |user|
    rand(1..10).times do
    new_skill = Skill.create(
        name: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        user_id: user.id
    )
end
end


puts 'Done seeding'