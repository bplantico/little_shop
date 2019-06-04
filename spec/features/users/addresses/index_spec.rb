require 'rails_helper'

RSpec.describe 'user addresses', type: :feature do
  before :each do
    @user_1 = create(:user)
    @user_2 = create(:user)

    @a1   = Address.create!(active: true, nickname: "home", street_address: "123 Home St", city: "Hometown", state: "Colorado", zip: "80216", user_id: @user_1.id)
    @a2   = Address.create!(active: false, nickname: "work", street_address: "456 Work St", city: "Worktown", state: "Colorado", zip: "80216", user_id: @user_1.id)
    @a3   = Address.create!(active: true, nickname: "home", street_address: "2 User St", city: "Usertwotown", state: "Colorado", zip: "80216", user_id: @user_2.id)

    @o1 = Order.create(user: @user_1, status: :pending, address_id: @a1.id)
    @o2 = Order.create(user: @user_1, status: :shipped, address_id: @a2.id)

    visit login_path
    fill_in "Email", with: @user_1.email
    fill_in "Password", with: @user_1.password
    click_button("Log in")
    visit profile_path

  end

  it "clicking the 'Manage Addresses' link takes me to a page with all of my addresses" do

    click_link("Manage Addresses")

    expect(current_path).to eq(profile_addresses_path)

    expect(page).to have_link("Add New Address")

    within "#address-#{@a1.id}" do
      expect(page).to have_content("#{@a1.nickname}")
      expect(page).to have_content("#{@a1.street_address}")
      expect(page).to have_content("#{@a1.city}")
      expect(page).to have_content("#{@a1.state}")
      expect(page).to have_content("#{@a1.zip}")
    end

    within "#address-#{@a2.id}" do
      expect(page).to have_content("#{@a2.nickname}")
      expect(page).to have_content("#{@a2.street_address}")
      expect(page).to have_content("#{@a2.city}")
      expect(page).to have_content("#{@a2.state}")
      expect(page).to have_content("#{@a2.zip}")
    end

    expect(page).to_not have_content("#{@a3.street_address}")
  end

  it "for each address, I see a link or button to edit or delete the address" do

    click_link("Manage Addresses")

    within "#address-#{@a1.id}" do
      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end

    within "#address-#{@a2.id}" do
      expect(page).to_not have_link("Edit")
      expect(page).to_not have_link("Delete")
    end
  end

  it "clicking a link or button to edit an address takes me to an edit form" do

    click_link("Manage Addresses")
    
    within "#address-#{@a1.id}" do
      click_link("Edit")
    end

    expect(current_path).to eq(edit_profile_address_path(@a1.id))

    expect(page).to have_css("input[value='home']")
    expect(page).to have_css("input[value='123 Home St']")
    expect(page).to have_css("input[value='Hometown']")
    expect(page).to have_css("input[value='Colorado']")
    expect(page).to have_css("input[value='80216']")

    fill_in :address_nickname, with: "updated nickname"
    fill_in :address_street_address, with: "updated street"
    fill_in :address_city, with: "updated city"
    fill_in :address_state, with: "updated state"
    fill_in :address_zip, with: "updated zip"

    click_button "Update Address"

    expect(current_path).to eq(profile_addresses_path)

    within "#address-#{@a1.id}" do
      expect(page).to have_content("updated nickname")
      expect(page).to have_content("updated street")
      expect(page).to have_content("updated city")
      expect(page).to have_content("updated state")
      expect(page).to have_content("updated zip")
    end

  end

  it "clicking link to delete address removes the address from my profile" do

    click_link("Manage Addresses")

    within "#address-#{@a1.id}" do
      click_link("Delete")
    end

    expect(current_path).to eq(profile_addresses_path)

    expect(page).to_not have_content("#{@a1.nickname}")
    expect(page).to_not have_content("#{@a1.street_address}")

  end

  it "clicking the 'Add New Address' link takes me to a form where I can add a new address" do

    visit profile_addresses_path

    click_link("Add New Address")

    expect(current_path).to eq(new_profile_address_path)

    fill_in :address_nickname, with: "second address nickname"
    fill_in :address_street_address, with: "street 2"
    fill_in :address_city, with: "city 2"
    fill_in :address_state, with: "state 2"
    fill_in :address_zip, with: "zip 2"

    click_button "Add Address"

    expect(current_path).to eq(profile_addresses_path)

    new_address = Address.last
    expect(new_address.nickname).to eq("second address nickname")
    expect(new_address.street_address).to eq("street 2")
    expect(new_address.city).to eq("city 2")
    expect(new_address.state).to eq("state 2")
    expect(new_address.zip).to eq("zip 2")

  end

  it "address cannot be deleted if an order was shipped to it"
  it "what to do if address is tied to a pending order"

end
