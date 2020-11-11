FactoryBot.define do
  factory :order_address do
    token           { 'tok_abcdefghijklmnopqrstu0000000' }
    user_id         { '1' }
    sale_id         { '1' }
    zip_code        { '123-4567' }
    prefecture_id   { Faker::Number.between(from: 1, to: 47) }
    city            { '大阪市' }
    street          { '1-23' }
    building        { '' }
    phone_number    { Faker::Number.number(digits: 11) }
  end
end
