require 'rails_helper'

RSpec.describe 'user profile', type: :feature do
  before :each do
    @user_1 = create(:user)
    @user_2 = create(:user)

    @a1   = Address.create!(active: true, nickname: "home", street_address: "123 Home St", city: "Hometown", state: "Colorado", zip: "80216", user_id: @user_1.id)
    @a2   = Address.create!(active: false, nickname: "work", street_address: "456 Work St", city: "Worktown", state: "Colorado", zip: "80216", user_id: @user_1.id)
    @a3   = Address.create!(active: true, nickname: "home", street_address: "2 User St", city: "Usertwotown", state: "Colorado", zip: "80216", user_id: @user_2.id)
  end

  describe 'registered user visits their profile' do
    it 'shows user information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

      visit profile_path

      within '#profile-data' do
        expect(page).to have_content("Role: #{@user_1.role}")
        expect(page).to have_content("Email: #{@user_1.email}")
        within '#address-details' do
          expect(page).to have_content("Address: #{@user_1.address}")
          expect(page).to have_content("#{@user_1.city}, #{@user_1.state} #{@user_1.zip}")
          expect(page).to have_link("Manage Addresses")
          expect(page).to have_link("Add New Address")
        end
        expect(page).to have_link('Edit Profile Data')
      end
    end
  end

  describe 'registered user edits their profile' do
    describe 'edit user form' do
      it 'pre-fills form with all but password information' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

        visit profile_path

        click_link 'Edit'

        expect(current_path).to eq('/profile/edit')
        expect(find_field('Name').value).to eq(@user_1.name)
        expect(find_field('Email').value).to eq(@user_1.email)

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
          login_as(@user_1)
          old_digest = @user_1.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email

          fill_in :user_password, with: @updated_password
          fill_in :user_password_confirmation, with: @updated_password

          click_button 'Submit'

          updated_user = User.find(@user_1.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
          end
          expect(updated_user.password_digest).to_not eq(old_digest)
        end

        scenario 'works if no password is given' do
          login_as(@user_1)
          old_digest = @user_1.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email

          click_button 'Submit'

          updated_user = User.find(@user_1.id)

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
      login_as(@user_1)

      visit edit_profile_path

      fill_in :user_email, with: 'megan@example.com'

      click_button 'Submit'

      expect(page).to have_content("Email has already been taken")
    end
  end
end
