class WelcomeController < ApplicationController
  def home
    # if user_signed_in?
    #   # 如果用户已经登录，重定向到某个其他页面
    #   redirect_to some_other_path
    # else
      # 如果用户未登录，重定向到 Devise 的登录页面
      redirect_to new_user_session_path
    # end
  end
end
