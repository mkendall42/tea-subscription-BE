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

  def update
    #update - change the status of one
    subscription = Subscription.find(params[:id])
    old_status = subscription.status
    #Do the actual update (assuming valid params only)
    #Probably need internal error/exception handling in here (might separate into new and save)
    subscription.update!(subscription_params)

    # binding.pry

    # render json: { key: "value" }
    render json: SubscriptionsSerializer.format_updated_subscription(subscription, old_status)
  end

  private

  def subscription_params
    params.permit(:id, :status)
  end

  def invalid_subscription(exception)
    render json: { status: 404, message: exception.message }, status: 404
  end
end