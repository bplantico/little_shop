class Address < ApplicationRecord

  belongs_to :user

  validates_presence_of :nickname,
                        :street_address,
                        :city,
                        :state,
                        :zip


end
