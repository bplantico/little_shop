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
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Your Address has been updated!"
      redirect_to profile_addresses_path
    else
      flash[:danger] = @address.errors.full_messages
      @address = Address.find(params[:id])
      render :edit
    end
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
