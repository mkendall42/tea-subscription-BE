class Api::V1::SubscriptionsController < ApplicationController
  def index
    #Get all subscriptions
    render json: { key: "value" }
  end

  #index - get all
  #show - get details of one
  #update - change the status of one
end