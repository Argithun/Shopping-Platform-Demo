class CartItemsController < ApplicationController
    before_action :authenticate_user!

    def index
        @cart_items = current_user.cart_items
    end

    def create
      @product = Product.find(params[:product_id])
      quantity = params[:quantity].to_i
    
      if quantity > 0
        existing_cart_item = current_user.cart_items.find_by(product_id: @product.id)
    
        if existing_cart_item
          existing_cart_item.quantity += quantity
          existing_cart_item.cost = existing_cart_item.quantity * @product.price
          existing_cart_item.save
          redirect_to cart_items_path, notice: "Product quantity updated in your cart."
        else
          @cart_item = current_user.cart_items.build(
            product: @product,
            product_name: @product.name,
            user_email: current_user.email,
            quantity: quantity,
            cost: quantity * @product.price,
            added_at: Time.now
          )
          if @cart_item.save
            redirect_to cart_items_path, notice: "Product added to your cart."
          else
            redirect_to product_path(@product), alert: "Failed to add the product to your cart."
          end
        end
      else
        redirect_to product_path(@product), alert: "Please enter a valid quantity (greater than 0)."
      end
    end

    # 编辑购物车条目
    def edit
      @cart_item = CartItem.find(params[:id])
    end

    # 更新购物车条目
    def update
      @cart_item = CartItem.find(params[:id])

      if @cart_item.update(cart_item_params)
        # 更新购物车条目的 cost
        @cart_item.cost = @cart_item.quantity * @cart_item.product.price
        @cart_item.save

        redirect_to cart_items_path, notice: "Cart item has been updated."
      else
        render :edit
      end
    end    


    def destroy
      @cart_item = current_user.cart_items.find(params[:id])
      @cart_item.destroy!
      redirect_to cart_items_path, notice: "Cart item removed."
    end

    private

    def cart_item_params
      params.require(:cart_item).permit(:user_email, :product_name, :quantity, :added_at)
    end
end
