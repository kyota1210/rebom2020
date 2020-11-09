FactoryBot.define do
  factory :sale do
    status_id         { Faker::Number.between(from: 1, to: 5) }
    transfer_fee_id   { Faker::Number.between(from: 1, to: 2) }
    price             { Faker::Number.between(from: 300, to: 9_999_999) }

    association :book
  end
end
