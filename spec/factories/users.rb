FactoryBot.define do
  factory :user do
    name                  { Faker::Name.initials }
    email                 { Faker::Internet.free_email }
    password              { '123abc' }
    password_confirmation { password }

    after(:create) do |item|
      item.image.attach(io: File.open('public/images/user_test_image.png'), filename: 'user_test_image.png')
    end
  end
end
