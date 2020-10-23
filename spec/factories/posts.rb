FactoryBot.define do
  factory :post do
    highlight   { 'ハイライト' }
    text        { Faker::Lorem.characters(number: 200) }

    association :book
  end
end
