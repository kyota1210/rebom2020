FactoryBot.define do
  factory :book_sale do
    status         { Faker::Number.between(from: 1, to: 5) }
    transfer_fee   { Faker::Number.between(from: 1, to: 2) }
    price { Faker::Number.between(from: 3, to: 9_999_999) }
  end
end
