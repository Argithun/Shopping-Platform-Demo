class ProductsController < ApplicationController
  before_action :authenticate_admin, only: [:new, :create, :edit, :update, :destroy]

  # 商品列表页面
  def index
    @products = Product.all
  end

  # 商品详情页面
  def show
    @product = Product.find(params[:id])
  end


  # 创建新商品（仅管理员可访问）
  def new
    @product = Product.new
  end

  # 保存新商品（仅管理员可访问）
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  # 编辑商品（仅管理员可访问）
  def edit
    @product = Product.find(params[:id])
  end

  # 更新商品（仅管理员可访问）
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  # 删除商品（仅管理员可访问）
  def destroy
    @product = Product.find(params[:id])
    @product.destroy!
    redirect_to products_url, notice: "Product was successfully deleted."
  end

  # ...

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :sales, :image_path, :product_type, :color)
  end

  def authenticate_admin
    # 仅管理员角色用户可以访问
    unless current_user.role == 'admin'
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
