# this rake task uses Faker gem to populate the local database see 9.3.2
namespace :db do
  desc "Fill database with sample data"
# this line provides rake access to the local database environment
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
# the exclamation here raises an exception(noisy) if invalid for debugging
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end