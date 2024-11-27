class FavoritesController < ApplicationController
    before_action :authenticate_user! # 确保用户已登录才能访问这些动作
  
  
    def create
      @product = Product.find(params[:product_id])
      
      # 检查是否已经存在同名的收藏
      existing_favorite = current_user.favorites.find_by(name: @product.name)
    
      if existing_favorite
        redirect_to favorites_path, alert: "You have already added this product to favorites."
      else
        @favorite = current_user.favorites.build(
          name: @product.name,
          description: @product.description,
          price: @product.price,
          sales_count: @product.sales,
          image_url: @product.image_path,
          product_type: @product.product_type,
          color: @product.color
        )

        if @favorite.save
          redirect_to favorites_path, notice: "Product added to favorites."
        else
          redirect_to products_path, alert: "Failed to add the product to favorites."
        end
      end
    end

    def index
      @favorites = current_user.favorites # 显示当前用户的所有收藏
    end
      
    def show
      @favorite = Favorite.find(params[:id])
    end
  
    def destroy
      @favorite = current_user.favorites.find(params[:id])
      @favorite.destroy!
      redirect_to favorites_path, notice: "Favorite removed."
    end

    private

    def favorite_params
      params.require(:favorite).permit(:name, :description, :price, :sales_count, :image_url, :product_type, :color)
    end

end

  