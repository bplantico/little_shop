class Address < ApplicationRecord

  belongs_to :user
  has_many :orders, dependent: :destroy


  validates_presence_of :street_address,
                        :city,
                        :state,
                        :zip

  validates :nickname, presence: true

  def shipped_to?
     if Order.where(address_id: id, status: 'shipped').empty? || Order.where(address_id: id, status: 'status').nil?
       false
     else
       true
     end
  end

end
