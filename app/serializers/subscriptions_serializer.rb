class SubscriptionsSerializer
  def self.format_subscriptions
    titles = Subscription.all.map do |subscription|
      subscription.title
    end

    {
      data: {
        subscription_titles: titles,
        total_subscriptions: Subscription.count
      }
    }
  end
end