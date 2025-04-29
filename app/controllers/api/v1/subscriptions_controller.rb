class Api::V1::SubscriptionsController < ApplicationController
  def index
    #Get all subscriptions
    render json: SubscriptionsSerializer.format_subscriptions
  end

  def show
    #Get details for one subscription
    render json: { key: "value" }
  end

  #update - change the status of one
end