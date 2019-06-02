require 'rails_helper'

RSpec.describe 'the registration page' do
  describe 'happy path' do
    it "should create a new user and address after filling out the form" do
      visit registration_path

      fill_in :user_name, with: "name"

      fill_in :addresses_nickname, with: "home"
      fill_in :addresses_street_address, with: "address 1"
      fill_in :addresses_city, with: "city 1"
      fill_in :addresses_state, with: "state 1"
      fill_in :addresses_zip, with: "zip 1"

      fill_in :user_email, with: "example@gmail.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"

      click_button "Submit"

      expect(current_path).to eq(profile_path)

      user = User.last
      address = Address.last

      expect(page).to have_content("Registration Successful! You are now logged in.")
      expect(page).to have_content("Logged in as #{user.name}")

      expect(address).to be_a(Address)
    end
  end

  describe 'sad path' do
    it "should display error messages for each unfilled field" do
      visit registration_path

      click_button "Submit"

      expect(current_path).to eq(registration_path)

      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Email can't be blank")
    end

    xit "should display an error when an email is taken" do
      user = create(:user)
      user.update(email: "example@gmail.com")

      visit registration_path

      fill_in :user_name, with: "name_1"

      fill_in :addresses_nickname, with: "home"
      fill_in :addresses_street_address, with: "address_1"
      fill_in :addresses_city, with: "city_1"
      fill_in :addresses_state, with: "state_1"
      fill_in :addresses_zip, with: "zip_1"

      fill_in :user_email, with: "example@gmail.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"

      click_button "Submit"

      expect(current_path).to eq(registration_path)
      expect(page).to have_content("Email has already been taken")

      expect(page).to have_css("input[value='name_1']")
      expect(page).to have_css("input[value='address_1']")
      expect(page).to have_css("input[value='city_1']")
      expect(page).to have_css("input[value='state_1']")
      expect(page).to have_css("input[value='zip_1']")
      expect(page).to_not have_css("input[value='example@gmail.com']")
      expect(page).to_not have_css("input[value='password']")
    end

    it "should display an error when password confirmation doesn't match" do
      visit registration_path

      fill_in :user_name, with: "name"

      fill_in :addresses_nickname, with: "home"
      fill_in :addresses_street_address, with: "address"
      fill_in :addresses_city, with: "city"
      fill_in :addresses_state, with: "state"
      fill_in :addresses_zip, with: "zip"

      fill_in :user_email, with: "example@gmail.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "a different password"

      click_button "Submit"

      expect(current_path).to eq(registration_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
