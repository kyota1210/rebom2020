FactoryBot.define do
  factory :book do
    title       { '本のタイトル' }
    author      { '著者名' }

    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
