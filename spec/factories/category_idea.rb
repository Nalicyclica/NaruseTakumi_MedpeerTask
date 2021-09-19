FactoryBot.define do
  factory :category_idea do
    name { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
  end
end
