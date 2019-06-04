require 'rails_helper'

RSpec.describe Coupon, type: :model do

  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :active }
    it { should validate_presence_of :discount_amount }
    it { should validate_numericality_of(:discount_amount).is_greater_than_or_equal_to(0) }
    
  end

end
