class Profile::AddressesController < ApplicationController

  def index
    # require "pry"; binding.pry
    @user = current_user
    @addresses = current_user.addresses
  end

end
