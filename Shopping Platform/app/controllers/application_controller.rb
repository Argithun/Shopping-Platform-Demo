class ApplicationController < ActionController::Base
    before_action :authenticate_user!
  
    def after_sign_in_path_for(resource)
      products_index_path  # 这里指定用户登录后跳转的页面
    end
end
  