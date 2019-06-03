class Profile::AddressesController < ApplicationController

  def index
    @user = current_user
    @addresses = current_user.addresses
  end

  def edit
  end

end
