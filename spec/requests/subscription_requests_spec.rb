require "rails_helper"

RSpec.describe "SubscriptionsController requests", type: :request do
  before(:each) do
    #Create customers
    @customer1 = Customer.create!(first_name: "Jean Luc", last_name: "Picard", email: "jpicard_tng@federation.gov", address: "1701D: 001")
    @customer2 = Customer.create!(first_name: "Kathryn", last_name: "Janeway", email: "kjaneway_voy@federation.gov", address: "1701E: 001")
    #Create teas
    @tea1 = Tea.create!(title: "Earl Grey", description: "Only one way to be served: hot", temperature: 90, brew_time: 150)
    @tea2 = Tea.create!(title: "Chai", description: "A good combo of spices", temperature: 80, brew_time: 100)
    @tea3 = Tea.create!(title: "Mint", description: "Potent spice - must be stored separately", temperature: 75, brew_time: 90)
    #Associate 'em via subscriptions
    @subscription1 = Subscription.create!(title: "Earl Grey standard issue", status: "active", price: 44.95, frequency: 4.2, customer_id: @customer1.id, tea_id: @tea1.id)
    @subscription2 = Subscription.create!(title: "My Chai bundle", status: "active", price: 64.00, frequency: 5, customer_id: @customer2.id, tea_id: @tea2.id)
    @subscription3 = Subscription.create!(title: "Mint seasonal deal", status: "cancelled", price: 29.99, frequency: 2.5, customer_id: @customer2.id, tea_id: @tea3.id)
  end

  describe "#index - get all subscriptions" do
    it "gets correct list of subscriptions with correct data" do
      get api_v1_subscriptions_path
      subscriptions_info = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(subscriptions_info).to have_key(:data)
      expect(subscriptions_info[:data]).to have_key(:subscriptions)
      subscriptions_info[:data][:subscriptions].each do |subscription|
        expect(subscription).to have_key(:title)
        expect(subscription[:title]).to be_a(String)
        expect(subscription).to have_key(:id)
        expect(subscription[:id]).to be_a(Integer)
        expect(subscription).to have_key(:status)
        expect(["active", "cancelled"]).to include(subscription[:status])
      end
      expect(subscriptions_info[:data][:subscriptions][1][:title]).to eq("My Chai bundle")
      expect(subscriptions_info[:data][:subscriptions][1][:id]).to eq(@subscription2.id)
      expect(subscriptions_info[:data][:subscriptions][1][:status]).to eq("active")
      expect(subscriptions_info[:data]).to have_key(:total_subscriptions)
      expect(subscriptions_info[:data][:total_subscriptions]).to eq(3)
    end

  end

  describe "#show - get details for a single subscription" do
    context "happy paths" do
      it "correctly returns all data for single subscription" do
        get api_v1_subscription_path(@subscription3.id)
        detailed_info = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(detailed_info).to have_key(:data)
        expect(detailed_info[:data]).to have_key(:id)
        expect(detailed_info[:data][:id]).to eq(@subscription3.id)
        expect(detailed_info[:data]).to have_key(:title)
        expect(detailed_info[:data][:title]).to eq("Mint seasonal deal")

        expect(detailed_info[:data]).to have_key(:customer)
        expect(detailed_info[:data][:customer][:first_name]).to eq("Kathryn")
        expect(detailed_info[:data][:customer][:last_name]).to eq("Janeway")
        expect(detailed_info[:data][:customer][:id]).to eq(@customer2.id)
        expect(detailed_info[:data][:customer][:email]).to eq("kjaneway_voy@federation.gov")
        expect(detailed_info[:data][:customer][:address]).to eq("1701E: 001")

        expect(detailed_info[:data]).to have_key(:tea)
        expect(detailed_info[:data][:tea][:title]).to eq("Mint")
        expect(detailed_info[:data][:tea][:id]).to eq(@tea3.id)
        expect(detailed_info[:data][:tea][:description]).to eq("Potent spice - must be stored separately")
        expect(detailed_info[:data][:tea][:temperature]).to eq(75)
        expect(detailed_info[:data][:tea][:brew_time]).to eq(90)

        expect(detailed_info[:data]).to have_key(:status)
        expect(detailed_info[:data][:status]).to eq("cancelled")

        expect(detailed_info[:data]).to have_key(:price)
        expect(detailed_info[:data][:price]).to eq(29.99)
        
        expect(detailed_info[:data]).to have_key(:frequency)
        expect(detailed_info[:data][:frequency]).to eq(2.5)
      end

    end

    context "sad paths" do
      it "invalid ID / subscription not found" do
        invalid_id = 10000
        get api_v1_subscription_path(invalid_id)
        error_message = JSON.parse(response.body, symbolize_names: true)   

        expect(response).to_not be_successful
        expect(error_message).to have_key(:status)
        expect(error_message[:status]).to eq(404)
        expect(error_message[:status]).to eq(404)
        expect(error_message).to have_key(:message)
        expect(error_message[:message]).to eq("Couldn't find Subscription with 'id'=#{invalid_id}")
      end

      #No associated customers or teas gives appropriate error / JSON response
    end
  end

  describe "#update - change or cancel subscription" do
    context "happy paths" do
      it "successfully cancels an active subscription" do
        #Cancel the Earl Grey for Picard - i.e. something that would NEVER happen
        update_params = { status: "cancelled" }
        patch api_v1_subscription_path(@subscription1.id), params: update_params, as: :json     #Are more detailed headers ever necessary here?
        updated_subscription_info = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to be_successful
        expect(updated_subscription_info).to have_key(:data)
        expect(updated_subscription_info[:data]).to have_key(:subscription_id)
        expect(updated_subscription_info[:data][:subscription_id]).to eq(@subscription1.id)
        expect(updated_subscription_info[:data]).to have_key(:old_status)
        expect(updated_subscription_info[:data][:old_status]).to eq("active")
        expect(updated_subscription_info[:data]).to have_key(:new_status)
        expect(updated_subscription_info[:data][:new_status]).to eq("cancelled")
      end

      it "no error occurs when status is set to same as before" do
        #Picard wants to be SURE he's still subscribed
        update_params = { status: "active" }
        patch api_v1_subscription_path(@subscription1.id), params: update_params, as: :json     #Are more detailed headers ever necessary here?
        updated_subscription_info = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(updated_subscription_info[:data][:old_status]).to eq(updated_subscription_info[:data][:new_status])
      end

    end

    context "sad paths" do
      it "invalid ID / subscription to update not found" do
        invalid_id = 10001
        update_params = { status: "cancelled" }
        patch api_v1_subscription_path(invalid_id), params: update_params, as: :json
        error_message = JSON.parse(response.body, symbolize_names: true) 

        expect(response).to_not be_successful
        expect(error_message).to have_key(:status)
        expect(error_message[:status]).to eq(404)
        expect(error_message[:status]).to eq(404)
        expect(error_message).to have_key(:message)
        expect(error_message[:message]).to eq("Couldn't find Subscription with 'id'=#{invalid_id}")
      end

      it "no error occurs when attempting to set status to same value" do
        update_params = { status: "cancelled" }
        patch api_v1_subscription_path(@subscription3.id), params: update_params, as: :json
        updated_subscription_info = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to be_successful
        expect(updated_subscription_info[:data][:subscription_id]).to eq(@subscription3.id)
        expect(updated_subscription_info[:data][:old_status]).to eq(updated_subscription_info[:data][:new_status])
      end

      it "additional / invalid params do not change anything beyond 'status'" do
        update_params = {
          status: "cancelled",
          customer_id: @customer1.id,
          created_at: DateTime.now,
          random_param: "I'm sneakin' in!"
        }
        patch api_v1_subscription_path(@subscription2.id), params: update_params, as: :json
        updated_subscription_info = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(updated_subscription_info[:data][:subscription_id]).to eq(@subscription2.id)
        expect(updated_subscription_info[:data][:old_status]).to eq("active")
        expect(updated_subscription_info[:data][:new_status]).to eq("cancelled")
        expect(Subscription.find(@subscription2.id).customer_id).to eq(@customer2.id)
        #Verify e.g. no new field exists in the DB due to the sneaky param
        expect{ (Subscription.pluck(:random_param)) }.to raise_error(ActiveRecord::StatementInvalid)
      end

      it "invalid 'status' string generates appropriate error" do
        update_params = { status: "hyperactive" }
        patch api_v1_subscription_path(@subscription1.id), params: update_params, as: :json
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(error_message[:status]).to eq(422)
        expect(error_message[:message]).to eq("Validation failed: Status is not included in the list ('active' or 'cancelled').")
      end

    end
  end

end