# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  User.create({
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.free_email,
    password_digest: Faker::Internet.password,
    admin: [true, false].sample,
    business_id: 1
  })
end
50.times do
  Customer.create({
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.free_email,
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip_code: Faker::Address.zip,
    gate_code: Faker::Address.postcode,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    filter_type: ['ProPump 3000', 'PumpLite', 'PowerPump 2500'].sample,
    pump_type:['Hayward 1500', 'Canister filter 2000'].sample,
    user_id: 1,
    weekly_complete: false,
    monday: [true, false].sample,
    tuesday: [true, false].sample,
    wednesday: [true, false].sample,
    thursday: [true, false].sample,
    friday: [true, false].sample,
    receive_emails: [true, false].sample,
  })
end
5.times do
  Note.create({
    customer_id: [1, 2, 3, 4, 5].sample,
    description: Faker::ChuckNorris.fact
  })
end
20.times do
  Repair.create({
    customer_id: [1, 2, 3, 4, 5].sample,
    user_id: 1,
    title: "The motor is making a loud noise.",
    description: Faker::ChuckNorris.fact,
    complete: [true, false].sample
  })
end
20.times do
  Visit.create({
    user_id: 1,
    customer_id: [1, 2, 3, 4, 5].sample,
    chlorine:[88, 99, 77, 66].sample,
    ph: [88, 99, 77, 66].sample,
    alkalinity: [88, 99, 77, 66].sample,
    stabilizer: [88, 99, 77, 66].sample,
    salt: [88, 99, 77, 66].sample,
    clean_tile: [true, false].sample,
    leaf_net: [true, false].sample,
    vacuum: [true, false].sample,
    brush: [true, false].sample,
    skimmer_basket: [true, false].sample,
    pump_basket: [true, false].sample,
    clean_filters: [true, false].sample,
    new_filters: [true, false].sample,
    add_chlorine: [true, false].sample,
    add_acid: [true, false].sample,
    add_bicarb: [true, false].sample,
    add_stabilizer: [true, false].sample,
    add_chlorine_tab: [true, false].sample
  })
end