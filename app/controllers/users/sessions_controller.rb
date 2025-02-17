# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to mypage_users_path, notice: "ゲストユーザーでログインしました。"
  end
  
  protected

  def after_sign_in_path_for(resource)
    mypage_users_path
  end
end
