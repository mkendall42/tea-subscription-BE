require "rails_helper"

RSpec.describe "SubscriptionsController requests", type: :request do
  before(:each) do
    #Create customers
    @customer1 = Customer.create!(first_name: "Jean Luc", last_name: "Picard", email: "jpicard_tng@federation.gov", address: "1701D: 001")
    @customer2 = Customer.create!(first_name: "Kathryn", last_name: "Janeway", email: "kjaneway_voy@federation.gov", address: "1701E: 001")
    #Create teas
    @tea1 = Tea.create!(title: "Earl Gray", description: "Only one way to be served: hot", temperature: 90, brew_time: 150)
    @tea2 = Tea.create!(title: "Chai", description: "A good combo of spices", temperature: 80, brew_time: 100)
    @tea3 = Tea.create!(title: "Mint", description: "Potent spice - must be stored separately", temperature: 75, brew_time: 90)
    #Associate 'em via subscriptions
    @subscription1 = Subscription.create!(title: "Early Gray standard issue", status: "active", price: 44.95, frequency: 4.2, customer_id: @customer1.id, tea_id: @tea1.id)
    @subscription1 = Subscription.create!(title: "My Chai bundle", status: "active", price: 64.00, frequency: 5, customer_id: @customer2.id, tea_id: @tea2.id)
    @subscription1 = Subscription.create!(title: "Mint seasonal deal", status: "cancelled", price: 29.99, frequency: 2.5, customer_id: @customer2.id, tea_id: @tea3.id)
  end

  describe "#index - get all subscriptions" do
    it "gets correct list of subscriptions with correct data" do
      get api_v1_subscriptions_path
      subscriptions_info = JSON.parse(response.body, symbolize_names: true)

      binding.pry

      # expect(response).to be_successful
      # expect(subscriptions_info).to have_key(:data)
      # expect(subscriptions_info[:data]).to have_key(:subscription_titles)
      # expect(subscriptions_info[:data][:subscription_titles]).to be_a(Array)
      # expect(subscriptions_info[:data][:subscription_titles].length).to eq(3)
      # expect(subscriptions_info[:data][:subscription_titles][1]).to eq("My Chai bundle")
      # expect(subscriptions_info[:data]).to have_key(:total_subscriptions)
      # expect(subscriptions_info[:data][:total_subscriptions]).to eq(3)
    end

  end
end