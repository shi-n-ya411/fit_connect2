class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  #フォロー機能
  def create
    user = User.find(params[:followed_id])
    current_user.following << user
    flash[:notice] = "#{user.name}さんをフォローしました。"
    redirect_to user_path(user)
  end

  #フォロー解除
  def destroy
    user = User.find(params[:id])
    current_user.following.delete(user)
    flash[:notice] = "#{user.name}さんのフォローを解除しました。"
    redirect_to user_path(user)
  end
end
