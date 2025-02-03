class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # 投稿一覧
  def index
    @posts = Post.order(created_at: :desc)
  end

  # 投稿詳細
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
  end

  # 新規投稿フォーム
  def new
    @post = current_user.posts.build
  end

  # 投稿作成
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: '投稿が作成されました。'
    else
      render :new, alert: '投稿の作成に失敗しました。'
    end
  end

  # 投稿編集フォーム
  def edit
  end

  # 投稿更新
  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました。'
    else
      render :edit, alert: '投稿の更新に失敗しました。'
    end
  end

  # 投稿削除
  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿が削除されました。'
  end

  # いいね一覧
  def liked
    @liked_posts = current_user.liked_posts.includes(:user).order(created_at: :desc)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: '投稿が見つかりませんでした。'
  end
  
  def authorize_user!
    redirect_to posts_path, alert: '権限がありません。' unless @post.user == current_user
  end
  
  def post_params
    params.require(:post).permit(:title, :image, :content)
  end
end
