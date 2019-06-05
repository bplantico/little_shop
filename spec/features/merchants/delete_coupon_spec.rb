require 'rails_helper'

RSpec.describe 'Merchant Dashboard Coupons page' do
  describe 'when trying to delete a coupon' do
    before :each do
      @merchant = create(:merchant)
      @coupon_1 = Coupon.create(code: "ONE1", active: true, discount_amount: 1, merchant_id: @merchant.id)
      @coupon_2 = Coupon.create(code: "TWO2", active: true, discount_amount: 2, merchant_id: @merchant.id)
    end

    describe 'works when nobody has used that coupon before' do
      scenario 'when logged in as merchant' do
        login_as(@merchant)
        visit dashboard_coupons_path

        within "#coupon-#{@coupon_1.id}" do
          click_button 'Delete Coupon'
        end

        @merchant.reload

        expect(current_path).to eq(dashboard_coupons_path)
        expect(page).to_not have_css("#coupon-#{@coupon_1.id}")
        expect(page).to_not have_content(@coupon_1.code)
        expect(page).to_not have_content(@coupon_1.discount_amount)
      end
    end

    describe 'fails if someone has used that coupon before' do
      xscenario 'when logged in as merchant' do
        login_as(@merchant)
        visit dashboard_coupons_path

        page.driver.delete(dashboard_item_path(@coupon_1))
        expect(page.status_code).to eq(302)

        visit dashboard_coupons_path

        expect(page).to have_css("#coupon-#{@coupon_1.id}")
        expect(page).to have_content("Attempt to delete #{@coupon_1.code} was thwarted!")
      end
    end
  end
end
