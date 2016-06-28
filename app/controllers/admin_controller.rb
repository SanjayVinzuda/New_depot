class AdminController < ApplicationController
  before_action :cartid
  
  def index
    @total_orders = Order.count
  end
end
