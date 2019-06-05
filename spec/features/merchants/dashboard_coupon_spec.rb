require 'rails_helper'

RSpec.describe 'Merchant Dashboard Coupons page' do
  describe "happy path" do
    it "creates a coupon" do
      @merchant = create(:merchant)
      login_as(@merchant)

      visit dashboard_coupons_path
      click_link "Create A Coupon"

      @new_code = "newcouponcode"
      @new_discount_amount = 1

      expect(current_path).to eq(new_dashboard_coupon_path)

      fill_in :coupon_code, with: @new_code
      fill_in :coupon_discount_amount, with: @new_discount_amount

      click_button "Create Coupon"

      new_coupon = Coupon.last

      expect(current_path).to eq(dashboard_coupons_path)
      expect(page).to have_content("Your coupon has been created!")

      within "#coupon-#{new_coupon.id}" do
        expect(page).to have_content(@new_code)
        expect(page).to have_content(@new_discount_amount)
        expect(page).to have_content("Status: Active")
        expect(page).to have_button("Deactivate Coupon")
      end
    end
  end
end
