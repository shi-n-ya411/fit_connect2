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
    @relationship = Relationship.find_by(id: params[:id])
    
    if @relationship.nil?
      flash[:alert] = "フォロー関係が見つかりません"
      redirect_to root_path and return
    end
    
    @relationship.destroy
    flash[:notice] = "フォローを解除しました"
    redirect_to @relationship.followed
  end
  
end
