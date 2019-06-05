require 'rails_helper'

RSpec.describe "Merchant editing an item" do
  before :each do
    @merchant = create(:merchant)
    @coupon = Coupon.create(code: "ONE", active: true, discount_amount: 1, merchant_id: @merchant.id)
    @updated_code = "UPDATED"
    @updated_discount_amount = "100"

    login_as(@merchant)
    visit dashboard_coupons_path

    within "#coupon-#{@coupon.id}" do
      click_link "Edit"
    end
  end

  describe "happy path" do
    it "has a form prepopulated with the coupon info" do
      expect(current_path).to eq(edit_dashboard_coupon_path(@coupon))

      expect(page).to have_css("[@value='#{@coupon.code}']")
      expect(page).to have_css("[@value='#{@coupon.discount_amount}']")

    end

    it "can edit a coupon" do
      fill_in :coupon_code, with: @updated_code
      fill_in :coupon_discount_amount, with: @updated_discount_amount

      click_button "Update Coupon"

      expect(current_path).to eq(dashboard_coupons_path)
      expect(page).to have_content("Your coupon has been updated!")

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_content(@updated_code)
        expect(page).to have_content(@updated_discount_amount)
        expect(page).to have_content("Status: Active")
        expect(page).to have_button("Deactivate Coupon")
      end
    end
  end

  describe "sad path" do
    it "cannot leave fields blank" do
      fill_in :coupon_code, with: ""
      fill_in :coupon_discount_amount, with: ""
      click_button "Update Coupon"

      expect(page).to have_content("Code can't be blank")
      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Price can't be blank")
      expect(page).to have_content("Inventory can't be blank")
    end

    it "cannot enter discount amount less than 0" do
      fill_in :item_price, with: "-1"
      click_button "Update Coupon"

      expect(page).to have_content("Disco
        unt amount must be greater than or equal to 0")
    end
  end
end
