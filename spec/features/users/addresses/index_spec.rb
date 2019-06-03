require 'rails_helper'

RSpec.describe 'user addresses', type: :feature do
  before :each do
    @user_1 = create(:user)
    @user_2 = create(:user)

    @a1   = Address.create!(active: true, nickname: "home", street_address: "123 Home St", city: "Hometown", state: "Colorado", zip: "80216", user_id: @user_1.id)
    @a2   = Address.create!(active: false, nickname: "work", street_address: "456 Work St", city: "Worktown", state: "Colorado", zip: "80216", user_id: @user_1.id)
    @a3   = Address.create!(active: true, nickname: "home", street_address: "2 User St", city: "Usertwotown", state: "Colorado", zip: "80216", user_id: @user_2.id)

    visit login_path
    fill_in "Email", with: @user_1.email
    fill_in "Password", with: @user_1.password
    click_button("Log in")
    visit profile_path

    click_link("Manage Addresses")

  end

  it "clicking the 'Manage Addresses' link takes me to a page with all of my addresses" do

    expect(current_path).to eq(profile_addresses_path)

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

    within "#address-#{@a1.id}" do
      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end

    within "#address-#{@a2.id}" do
      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end
  end

  it "clicking a link or button to edit an address takes me to an edit form" do

    within "#address-#{@a1.id}" do
      click_link("Edit")
    end

    expect(current_path).to eq(edit_profile_address_path(@a1.id))
  end

  it "clicking a link or button to edit an address takes me to an edit form" do

    within "#address-#{@a1.id}" do
      click_link("Delete")
    end

    expect(current_path).to eq(profile_addresses_path)
  end

  it "clicking the 'Add New Address' link takes me to a form to add a new address"
  it "address cannot be deleted if an order was shipped to it"
  it "what to do if address is tied to a pending order"


end
