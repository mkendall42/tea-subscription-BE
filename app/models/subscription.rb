class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :tea

  validates :title, presence: true
  validates :price, presence: true
  validates :frequency, presence: true, comparison: { less_than: 31.0 }
  validates :status, inclusion: ["active", "cancelled"]
end