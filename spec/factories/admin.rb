FactoryGirl.define do
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    email "test@testmail.com"
    password "adminadmin"
    admin      true
  end
end