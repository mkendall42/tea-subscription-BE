class Api::V1::SubscriptionsController < ApplicationController
  def index
    #Get all subscriptions
    render json: SubscriptionsSerializer.format_subscriptions
  end

  def show
    #Get details for one subscription
    subscription = Subscription.find(params[:id])
    # render json: { key: "value" }
    render json: SubscriptionsSerializer.format_single_subscription(subscription)
  end

  #update - change the status of one
end