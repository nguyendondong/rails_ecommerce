class CartsController < ApplicationController
  before_action :cart_items
  after_action :reload_cart

  def show
    @products = Product.where(id: @cart_items.keys)
    @order = Order.new if @products.any?
  end

  def create
    @cart_items[params[:product_id]] = @cart_items[params[:product_id]].to_i + params[:quantity].to_i
    flash[:notice] = "Product added to cart!"
    redirect_back(fallback_location: root_path)
  end

  def update
    @cart_items[params[:product_id]] = params[:quantity].to_i
    redirect_to action: :show
  end

  def destroy
    @cart_items.delete(params[:product_id])
    flash[:notice] = "Product removed from cart!"
    redirect_to action: :show
  end
end
