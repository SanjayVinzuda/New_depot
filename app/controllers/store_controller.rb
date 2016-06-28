class StoreController < ApplicationController
  skip_before_action :authorize
  def index
    @product = Product.all
    $date = Time.current # => Fri, 02 Mar 2012 00:00:00 JST +09:00
    @cart = current_cart
    #@cart = Cart.find(session[:cart_id])
    # @s = Cart.create  if Cart.find(session[:cart_id]).nil?

    # if @s.nil?
    #   @cart = Cart.create#(product_id: params[:product_id])
    #   session[:cart_id] = @cart.id
    # end


    #@cart = @s
    puts"=====================****======#{session[:cart_id]}============"
    puts"=====================****======#{@cart}============"
    puts"=====================sssss=====#{@s}============"



  end


  def mycart
    @cart= Cart.find_by(id: session[:cart_id])
    a = session[:cart_id]

    puts"===========================#{a}============"

    if @cart.nil?
      flash[:notice] = 'CART IS EMPTY.dsfsdfd....'
      redirect_to store_path, notice: 'The cart is empty'
    else
      redirect_to cart_path(@cart)
    end
  end


end
