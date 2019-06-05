class Dashboard::CouponsController < Dashboard::BaseController

  def index
    @coupons = current_user.coupons
    @merchant = current_user
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = current_user.coupons.new(coupon_params)
    if @coupon.save
      flash[:success] = "Your coupon has been created!"
      redirect_to dashboard_coupons_path
    else
      flash[:danger] = @coupon.errors.full_messages
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      # require "pry"; binding.pry
      flash[:success] = "Your coupon has been updated!"
      redirect_to dashboard_coupons_path
    else
      flash[:danger] = @coupon.errors.full_messages
      @coupon = Coupon.find(params[:id])
      render :edit
    end
  end

  private

  def coupon_params
    coupon_parameters = params.require(:coupon).permit(:code, :discount_amount, :active)
  end

end
