require 'rails_helper'

RSpec.describe 'user profile', type: :feature do
  before :each do
    @user = create(:user)
  end

  describe 'registered user visits their profile' do
    it 'shows user information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      within '#profile-data' do
        expect(page).to have_content("Role: #{@user.role}")
        expect(page).to have_content("Email: #{@user.email}")
        within '#address-details' do
          expect(page).to have_content("Address: #{@user.address}")
          expect(page).to have_content("#{@user.city}, #{@user.state} #{@user.zip}")
          expect(page).to have_link("Manage Addresses")
          expect(page).to have_link("Add New Address")
        end
        expect(page).to have_link('Edit Profile Data')
      end
    end

    xit "clicking the 'Manage Addresses' link takes me to a page with all of my addresses" do
      # @address_1 = create!(:address, user: @user, created_at: yesterday)

      visit login_path
  	  fill_in "Email", with: @user.email
  	  fill_in "Password", with: @user.password
  	  click_button("Log in")
      visit profile_path

      click_link("Manage Addresses")

      expect(current_path).to eq(profile_addresses_path)

      within "#address-#{@address.id}" do
        expect(page).to have_content("Nickname: #{@address.nickname}")
        expect(page).to have_content("#{@address.street_address}")
        expect(page).to have_content("#{@address.city}")
        expect(page).to have_content("#{@address.state}")
        expect(page).to have_content("#{@address.zip}")
      end

    end

    it "clicking the 'Add New Address' link takes me to a form to add a new address"

  end

  describe 'registered user edits their profile' do
    describe 'edit user form' do
      it 'pre-fills form with all but password information' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit profile_path

        click_link 'Edit'

        expect(current_path).to eq('/profile/edit')
        expect(find_field('Name').value).to eq(@user.name)
        expect(find_field('Email').value).to eq(@user.email)

        expect(find_field('Password').value).to eq(nil)
        expect(find_field('Password confirmation').value).to eq(nil)
      end
    end

    describe 'user information is updated' do
      before :each do
        @updated_name = 'Updated Name'
        @updated_email = 'updated_email@example.com'
        @updated_address = 'newest address'
        @updated_city = 'new new york'
        @updated_state = 'S. California'
        @updated_zip = '33333'
        @updated_password = 'newandextrasecure'
      end

      describe 'succeeds with allowable updates' do
        scenario 'all attributes are updated' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email

          # fill_in :addresses_nickname, with: "home"
          # fill_in :addresses_street_address, with: @updated_address
          # fill_in :addresses_city, with: @updated_city
          # fill_in :addresses_state, with: @updated_state
          # fill_in :addresses_zip, with: @updated_zip

          fill_in :user_password, with: @updated_password
          fill_in :user_password_confirmation, with: @updated_password

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
          end
          expect(updated_user.password_digest).to_not eq(old_digest)
        end

        scenario 'works if no password is given' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")

          end
          expect(updated_user.password_digest).to eq(old_digest)
        end
      end
    end

    it 'fails with non-unique email address change' do
      create(:user, email: 'megan@example.com')
      login_as(@user)

      visit edit_profile_path

      fill_in :user_email, with: 'megan@example.com'

      click_button 'Submit'

      expect(page).to have_content("Email has already been taken")
    end
  end
end
