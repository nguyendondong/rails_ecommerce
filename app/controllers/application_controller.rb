class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :load_categories

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_home_path : root_path
  end

  private

  def reload_cart
    cookies[:cart_items] = @cart_items.to_json
  end

  def cart_items
    cart_items_string = cookies[:cart_items]
    @cart_items = cart_items_string.present? ? JSON.parse(cart_items_string) : {}

    @cart_items.reject! do |product_id, quantity|
      Product.enabled.find_by(id: product_id).blank?
    end
  end

  def load_categories
    @categories = Category.all
  end

  def load_product
    return if @product = Product.find_by(id: params[:id])

    flash[:error] = "Product isn't exist!"
    redirect_to action: :index
  end

  def redirect_back_or(default)
    redirect_to session[:return_to] || default
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
