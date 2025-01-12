class LikesController < ApplicationController
  before_action :authenticate_user!

  #いいねをつける
  def create
    post = Post.find(params[:post_id])
    like = current_user.likes.new(post: post)

    if like.save
      flash[:notice] = 'いいねしました。'
    else
      flash[:alert] = 'いいねに失敗しました。'
    end
    redirect_to post_path(post)
  end

  #いいねの解除
  def destroy
    post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post: post)

    if like.destroy
      flash[:notice] = 'いいねを解除しました。'
    else
      flash[:alert] = 'いいねの解除に失敗しました。'
    end
    redirect_to post_path(post)
  end
end
