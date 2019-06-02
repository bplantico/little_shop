class Address < ApplicationRecord

  belongs_to :user

  validates_presence_of :street_address,
                        :city,
                        :state,
                        :zip

  validates :nickname, presence: true, uniqueness: true

end
