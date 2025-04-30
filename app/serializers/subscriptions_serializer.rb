class SubscriptionsSerializer
  def self.format_subscriptions
    titles = Subscription.all.map do |subscription|
      subscription.title
    end

    subscriptions_info = Subscription.all.map do |subscription|
      {
        title: subscription.title,
        id: subscription.id,
        status: subscription.status
      }
    end

    # {
    #   data: {
    #     subscription_titles: titles,
    #     total_subscriptions: Subscription.count
    #   }
    # }
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
          first_name: subscription.customer.first_name,
          last_name: subscription.customer.last_name,
          id: subscription.customer.id
        },
        tea: {
          title: subscription.tea.title,
          id: subscription.tea.id
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