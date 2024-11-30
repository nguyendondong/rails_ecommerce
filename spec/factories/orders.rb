FactoryBot.define do
  factory :order do
    phone { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address }
    status { Order.statuses.keys.first }
    user
  end
end
