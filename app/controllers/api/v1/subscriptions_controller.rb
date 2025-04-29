class Api::V1::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_subscription
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

  private

  def invalid_subscription(exception)
    render json: { status: 404, message: exception.message }, status: 404
  end
end