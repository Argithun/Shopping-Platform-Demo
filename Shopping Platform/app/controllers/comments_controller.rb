class CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def new
        @product = Product.find(params[:product_id])
        @comment = Comment.new
    end
  
    # 创建新评论
    def create
      @product = Product.find(params[:product_id])
      @comment = @product.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to product_path(@product), notice: 'Comment was successfully created.'
      else
        redirect_to product_path(@product), alert: 'Failed to create comment.'
      end
    end
  
    # 删除评论
    def destroy
      @comment = Comment.find(params[:id])
      @product = @comment.product
  
      if current_user == @comment.user
        @comment.destroy
        redirect_to product_path(@product), notice: 'Comment was successfully destroyed.'
      else
        redirect_to product_path(@product), alert: 'You do not have permission to delete this comment.'
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  