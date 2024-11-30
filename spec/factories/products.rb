FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { 100000 }
    category
  end
end
