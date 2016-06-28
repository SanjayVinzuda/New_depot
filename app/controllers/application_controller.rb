class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params

  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def cartid
    @cart = current_cart
  end

  private
  def current_cart
    @cart = Cart.find(session[:cart_id])
    # puts "hello============ #{session[:cart_id]}"
    # puts "tryyyyyy------------- #{@cart.id}"    # this get my session so don't use this
    # @cart
    #rescue ActiveRecord::RecondNotFound => e
  rescue Exception => e
    puts "Error =>>>>>>>>>>>>>#{e}"
    puts "=========================#{params[:product_id]}"

    @cart = Cart.create#(product_id: params[:product_id])
    session[:cart_id] = @cart.id
    @cart
  end

  protected
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_path, notice: "Please Log In."
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available."
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    { locale: I18n.locale}
  end

  # def mycart
  #   if @cart.nil?
  #     redirect_to root_path
  #   else
  #     a = session[:cart_id]
  #     puts"===========================#{a}============"
  #   end
  # end
end
