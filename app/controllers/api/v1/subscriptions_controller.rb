class Api::V1::SubscriptionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_subscription
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_status_param

  def index
    #Get all subscriptions
    render json: SubscriptionsSerializer.format_subscriptions
  end

  def show
    #Get details for one subscription
    subscription = Subscription.find(params[:id])
    render json: SubscriptionsSerializer.format_single_subscription(subscription)
  end

  def update
    #update - change the status of one subscription (with validation)
    subscription = Subscription.find(params[:id])
    old_status = subscription.status

    subscription.update!(subscription_params)

    render json: SubscriptionsSerializer.format_updated_subscription(subscription, old_status)
  end

  private

  def subscription_params
    params.permit(:id, :status)
  end

  def invalid_subscription(exception)
    render json: { status: 404, message: exception.message }, status: 404
  end

  def invalid_status_param(exception)
    render json: { status: 422, message: "#{exception.message} ('active' or 'cancelled')." }, status: 422
  end
end