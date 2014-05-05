FactoryGirl.define do
# tell FactoryGirl this is a user model and then define an example
  factory :user do
# sequences allow multiple definitions with n incrementing on each
# factory call.  This example is Person 1, Person 2....
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
# original single user definition example is just by attribute
#    name     "Michael Hartl"
#    email    "michael@example.com"
#    password "foobar"
#    password_confirmation "foobar"
  
  
    factory :admin do
        admin true
    end
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end

end
