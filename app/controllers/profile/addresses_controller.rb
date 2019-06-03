class Profile::AddressesController < ApplicationController

  def new
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

end
