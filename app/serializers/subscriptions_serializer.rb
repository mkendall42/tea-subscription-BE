class SubscriptionsSerializer
  def self.format_subscriptions
    subscriptions_info = Subscription.all.map do |subscription|
      {
        title: subscription.title,
        id: subscription.id,
        status: subscription.status
      }
    end

    {
      data: {
        subscriptions: subscriptions_info,
        total_subscriptions: Subscription.count
      }
    }
  end

  def self.format_single_subscription(subscription)
    {
      data: {
        id: subscription.id,
        title: subscription.title,
        status: subscription.status,
        price: subscription.price,
        frequency: subscription.frequency,
        customer: {
          id: subscription.customer.id,
          first_name: subscription.customer.first_name,
          last_name: subscription.customer.last_name,
          email: subscription.customer.email,
          address: subscription.customer.address
        },
        tea: {
          id: subscription.tea.id,
          title: subscription.tea.title,
          description: subscription.tea.description,
          temperature: subscription.tea.temperature,
          brew_time: subscription.tea.brew_time
        }
      }
    }
  end

  def self.format_updated_subscription(subscription, old_status)
    {
      data: {
        subscription_id: subscription.id,
        old_status: old_status,
        new_status: subscription.status
      }
    }
  end
end