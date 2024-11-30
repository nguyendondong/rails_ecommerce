class Admin::OrdersController < Admin::ApplicationController
  authorize_resource

  before_action :load_order, only: %i(edit update)
  
  def index
    @pagy, @orders = pagy(load_orders, items: Settings.order.admin.paginates)
  end

  def edit; end

  def update
    if @order.update(order_params)
      flash[:success] = "Order status updated successfully!"
      redirect_to admin_orders_path

      send_mail :confirm_order if @order.delivering?
      send_mail :reject_order if @order.canceled?
    else
      flash.now[:error] = "Failed to update order status!"
      render :edit
    end
  end

  private

  def send_mail(action)
    OrderMailer.with(order: @order.id).send(action).deliver_later
  end

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:error] = "Order isn't exist!"
    redirect_to action: :index
  end

  def load_orders
    return Order.all if params[:status].blank?

    Order.where(status: params[:status]) 
  end

  def order_params
    params.require(:order).permit(:status, :reason_description)
  end
end
