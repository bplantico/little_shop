require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe "Checking out" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item_1 = create(:item, user: @merchant_1, inventory: 3)
    @item_2 = create(:item, user: @merchant_2)
    @item_3 = create(:item, user: @merchant_2)

    visit item_path(@item_1)
    click_on "Add to Cart"
    visit item_path(@item_2)
    click_on "Add to Cart"
    visit item_path(@item_3)
    click_on "Add to Cart"
    visit item_path(@item_3)
    click_on "Add to Cart"
  end

  context "as a logged in regular user" do
    before :each do
      @user = create(:user)
      login_as(@user)
      visit cart_path
    end

    it "should let me pick which address to ship an order to" do

      Address.where(user_id: @user.id)&.destroy_all
      @a1 = Address.create!(active: true, nickname: "home", street_address: "123 Home St", city: "Hometown", state: "Colorado", zip: "80216", user_id: @user.id)
      @a2 = Address.create!(active: true, nickname: "work", street_address: "456 Work St", city: "Worktown", state: "Colorado", zip: "80216", user_id: @user.id)

      visit cart_path

      expect(page).to have_button("Check Out -- Ship to #{@a1.street_address} #{@a1.city} #{@a1.state} #{@a1.zip}")
      expect(page).to have_button("Check Out -- Ship to #{@a2.street_address} #{@a2.city} #{@a2.state} #{@a2.zip}")
    end

    it "should create a new order" do

      click_button "Check Out"
      @new_order = Order.last

      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Your order has been created!")
      expect(page).to have_content("Cart: 0")
      within("#order-#{@new_order.id}") do
        expect(page).to have_link("Order ID #{@new_order.id}")
        expect(page).to have_content("Status: pending")
      end
    end

    it "should create order items" do

      click_button "Check Out"
      @new_order = Order.last

      visit profile_order_path(@new_order)

      within("#oitem-#{@new_order.order_items.first.id}") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page.find("#item-#{@item_1.id}-image")['src']).to have_content(@item_1.image)
        expect(page).to have_content("Merchant: #{@merchant_1.name}")
        expect(page).to have_content("Price: #{number_to_currency(@item_1.price)}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Fulfilled: No")
      end

      within("#oitem-#{@new_order.order_items.second.id}") do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page.find("#item-#{@item_2.id}-image")['src']).to have_content(@item_2.image)
        expect(page).to have_content("Merchant: #{@merchant_2.name}")
        expect(page).to have_content("Price: #{number_to_currency(@item_2.price)}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Fulfilled: No")
      end

      within("#oitem-#{@new_order.order_items.third.id}") do
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@item_3.description)
        expect(page.find("#item-#{@item_3.id}-image")['src']).to have_content(@item_3.image)
        expect(page).to have_content("Merchant: #{@merchant_2.name}")
        expect(page).to have_content("Price: #{number_to_currency(@item_3.price)}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Fulfilled: No")
      end
    end
  end

  context "as a visitor" do
    it "should tell the user to login or register" do
      visit cart_path

      expect(page).to have_content("You must register or log in to check out.")
      click_link "register"
      expect(current_path).to eq(registration_path)

      visit cart_path

      click_link "log in"
      expect(current_path).to eq(login_path)
    end
  end
end
