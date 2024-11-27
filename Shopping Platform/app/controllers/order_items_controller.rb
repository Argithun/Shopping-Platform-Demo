class OrderItemsController < ApplicationController

    # 显示订单创建页面
  def new
    @cart_item = CartItem.find(params[:cart_item_id])
    @order_item = OrderItem.new(
      user_id: current_user.id,
      product_id: @cart_item.product_id,
      quantity: @cart_item.quantity,
      total_amount: @cart_item.cost,
      order_status: 'To be paid'
    )
  end

  # 创建订单
  def create
    @order_item = OrderItem.new(order_item_params)
  
    if @order_item.save
      # 订单创建成功，添加其他逻辑，例如清空购物车
      redirect_to order_items_path, notice: "Order Creation Success!"
    else
      render :new
    end
  end
  

  def index
    if current_user.role == 'buyer'
      # 如果是购买者，只显示当前用户的订单
      @order_items = current_user.order_items
    elsif current_user.role == 'admin'
      # 如果是管理员，显示所有待办订单
      @order_items = OrderItem.where(order_status: ["To be paid", "To be sent", "To be received"])
    else
      @order_items = []
    end
  end
  

  # 查看订单详情
  def show
    @order_item = OrderItem.find(params[:id])
    @product = Product.find(@order_item.product_id)
  end

  # 支付订单
  def pay
    @order_item = OrderItem.find(params[:id])
  
    if @order_item.order_status == "To be paid"
      if @order_item.update(order_status: "To be sent")
        redirect_to order_items_path, notice: "Order has been paid and is now being processed."
      else
        redirect_to order_items_path, alert: "Unable to process payment for this order."
      end
    else
      redirect_to order_items_path, alert: "Unable to process payment for this order."
    end
  end

  # 取消订单
  def cancel
    @order_item = OrderItem.find(params[:id])
  
    if @order_item.update(order_status: "Cancelled")
      redirect_to order_items_path, notice: "Order has been cancelled."
    else
      redirect_to order_items_path, alert: "Unable to cancel this order."
    end
  end

  # 确认收货
  def receive
    @order_item = OrderItem.find(params[:id])
  
    if @order_item.order_status == "To be received"
      if @order_item.update(order_status: "Completed")
        # 更新商品的销量
        product = @order_item.product
        new_sales_count = product.sales + @order_item.quantity
        product.update(sales: new_sales_count)

        redirect_to order_items_path, notice: "Cargo has been received."
      else
        redirect_to order_items_path, alert: "Unable to receive this cargo."
      end
    else
      redirect_to order_items_path, alert: "Unable to receive this cargo."
    end
  end

  # 发货
  def sent
    @order_item = OrderItem.find(params[:id])
  
    if @order_item.update(order_status: "To be received")
      redirect_to order_items_path, notice: "Cargo has been sent."
    else
      redirect_to order_items_path, alert: "Unable to send this cargo."
    end
  end

  # 拒绝
  def reject
    @order_item = OrderItem.find(params[:id])
  
    if @order_item.update(order_status: "Rejected")
      redirect_to order_items_path, notice: "Order has been rejected."
    else
      redirect_to order_items_path, alert: "Unable to reject this order."
    end
  end

  # 删除订单条目
  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_to order_items_path, notice: "Order item has been deleted."
  end


  def order_item_params
    params.require(:order_item).permit(:product_id, :user_id, :receiver, :shipping_address, 
        :phone_number, :postal_code, :quantity, :total_amount, :order_status)
  end
  
end
