FactoryGirl.define do
# tell FactoryGirl this is a user model and then define an example
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end