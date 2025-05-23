# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#For now, just use same info as in tests:
#Create customers
@customer1 = Customer.create!(first_name: "Jean Luc", last_name: "Picard", email: "jpicard_tng@federation.gov", address: "1701D: 001")
@customer2 = Customer.create!(first_name: "Kathryn", last_name: "Janeway", email: "kjaneway_voy@federation.gov", address: "1701E: 001")
@customer3 = Customer.create!(first_name: "Benjamin", last_name: "Sisko", email: "bsisko_ds9@federation.gov", address: "NX-74205: 001")
@customer4 = Customer.create!(first_name: "James", last_name: "Kirk", email: "jkirk_tos@federation.gov", address: "1701: 001")
#Create teas
@tea1 = Tea.create!(title: "Earl Grey", description: "Only one way to be served: hot", temperature: 90, brew_time: 150)
@tea2 = Tea.create!(title: "Chai", description: "A good combo of spices", temperature: 80, brew_time: 100)
@tea3 = Tea.create!(title: "Mint", description: "Potent spice - must be stored separately", temperature: 75, brew_time: 90)
@tea4 = Tea.create!(title: "Green", description: "Old school", temperature: 75, brew_time: 90)
@tea5 = Tea.create!(title: "Licorice", description: "The purer the licorice, the better", temperature: 75, brew_time: 90)
@tea6 = Tea.create!(title: "Sleepy Time", description: "In the old US, manufactured by Celetial Seasonings", temperature: 75, brew_time: 90)
#Associate 'em via subscriptions
@subscription1 = Subscription.create!(title: "Earl Grey standard issue", status: "active", price: 44.95, frequency: 4.2, customer_id: @customer1.id, tea_id: @tea1.id)
@subscription2 = Subscription.create!(title: "My Chai bundle", status: "active", price: 64.00, frequency: 5, customer_id: @customer2.id, tea_id: @tea2.id)
@subscription3 = Subscription.create!(title: "Mint seasonal deal", status: "cancelled", price: 29.99, frequency: 2.5, customer_id: @customer2.id, tea_id: @tea3.id)
@subscription4 = Subscription.create!(title: "Green tea megapack", status: "active", price: 130.00, frequency: 0.5, customer_id: @customer3.id, tea_id: @tea4.id)
@subscription5 = Subscription.create!(title: "Licorice, licorice, licorice!", status: "cancelled", price: 72.33, frequency: 1, customer_id: @customer4.id, tea_id: @tea5.id)
@subscription5 = Subscription.create!(title: "Sleep assist special", status: "cancelled", price: 39.99, frequency: 2, customer_id: @customer4.id, tea_id: @tea6.id)
