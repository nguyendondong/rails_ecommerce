class Admin::ProductsController < Admin::ApplicationController
  authorize_resource
  
  before_action :load_product, only: %i(edit update)

  def index
    @pagy, @products = pagy(load_products, items: Settings.product.paginates)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save 
      flash[:success] = t("admin.crud.product.success_message")
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit; end
  
  def update
    if @product.update(product_params)
      flash[:success] = t("admin.crud.product.success_message")
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  private

  def load_products
    return Product.all if params[:category_id].blank?

    Product.where(category_id: params[:category_id]) 
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :status, :category_id, :image, :body)
  end
end
