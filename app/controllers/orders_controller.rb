class OrdersController < ApplicationController
  skip_before_action :authorize, only: [:create, :new]
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :cartid
  

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      logger.error "Attempt to access invalid cart #{params[:id]}"
      #ErrorNotifier.notification(e).deliver   ##### new line
      redirect_to store_url, :notice => 'Invalid cart'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @cart }
      end
    end
  end
  #===========================================================================
  # def show
  # end

  # GET /orders/new
  def new
    @hide_checkout_button = true
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your Cart Is Empty..."
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
       # OrderNotifier.received(@order).deliver
        #  OrderNotifier.shipped(@order).deliver_now unless @order.ship_date.nil?
        format.html { redirect_to store_url, notice: 'Thank you for your order...' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  # def update
  #   respond_to do |format|
  #     if @order.update(order_params)
  #       format.html { redirect_to @order, notice: 'Order was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @order }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        Notifier.order_shipped(@order).deliver unless @order.ship_date.nil?
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    @hide_checkout_button = true

    params.require(:order).permit(:name, :address, :email, :pay_type, :ship_date)
  end
end
