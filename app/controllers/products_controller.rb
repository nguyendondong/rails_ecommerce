class ProductsController < ApplicationController
  authorize_resource

  before_action :load_product, only: %i(show)

  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy(@q.result, items: Settings.product.paginates)
  end

  def show
    return if @product.enabled?

    flash[:error] = "The product has been disabled and is not visible on websites"
    redirect_to action: :index
  end

  private

  def load_category
    return if @category = Category.find_by(id: params[:category_id])

    flash[:error] = "This category doesn't exist!"
    redirect_to root_path
  end

  def list_product
    return Product.enabled.search(params[:search_term]) if params[:search_term]

    return Product.enabled.where(category_id: params[:category_id]) if params[:category_id]

    Product.enabled
  end
end
