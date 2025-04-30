class Tea < ApplicationRecord
  has_many :subscriptions
  has_many :customers, through: :subscriptions

  validates :title, presence: true
  validates :description, presence: true
  validates :temperature, presence: true, comparison: { less_than: 100.0 }
  validates :brew_time, presence: true
end