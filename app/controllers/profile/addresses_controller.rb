class Profile::AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    @user = current_user
    @address = Address.new(address_params)
    @address.user_id = @user.id
    @address.save
    redirect_to profile_addresses_path
  end

  def index
    @user = current_user
    @addresses = current_user.addresses
  end

  def edit
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:active, :street_address, :city, :state, :zip, :nickname)
  end

end
