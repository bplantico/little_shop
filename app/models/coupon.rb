class Coupon < ApplicationRecord

  #relationships
  belongs_to :user, foreign_key: 'merchant_id'

  #validations
  validates :code, presence: true, uniqueness: true
  validates :active, presence: true
  validates :discount_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :merchant_id, presence: true

end
