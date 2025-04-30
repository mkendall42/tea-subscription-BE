class Customer < ApplicationRecord
  has_many :subscriptions
  has_many :teas, through: :subscriptions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true        #Later I could try to make a proc to check that e.g. "@" is present...
  validates :address, presence: true
end