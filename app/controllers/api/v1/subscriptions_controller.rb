class Api::V1::SubscriptionsController < ApplicationController
  def index
    #Get all subscriptions
    render json: SubscriptionsSerializer.format_subscriptions
  end

  #index - get all
  #show - get details of one
  #update - change the status of one
end