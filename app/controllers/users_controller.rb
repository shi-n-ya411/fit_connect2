class UsersController < ApplicationController
  # ログインしていないユーザーを弾く
  before_action :authenticate_user!, only: [:mypage, :following, :followers]
  # ユーザー情報を事前に取得
  before_action :set_user, only: [:show, :edit, :update]
  # ゲストログイン時に編集画面にアクセス制限
  before_action :ensure_guest_user, only: [:edit, :update]

   # マイページ
  def mypage
    # ログイン中のユーザー情報を取得
    @user = current_user
    if @user.present?
      @posts = Post.where(user: [@user] + @user.following).order(created_at: :desc)
    else
      flash[:alert] = "ログインしてください。"
      redirect_to new_user_session_path
    end
  end

  #フォロー機能
  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  # ユーザー詳細ページ
  def show
    return if @user.nil? # `set_user` の処理で `nil` の場合はリダイレクトされる
    @posts = @user.posts.order(created_at: :desc)
  end

  # プロフィール編集ページ
  def edit
    @user
  end

  # プロフィール更新処理
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールを更新しました。'
    else
      render :edit, alert: 'プロフィールの更新に失敗しました。'
    end
  end

   # アカウント削除処理
   def destroy
    if current_user == @user
      @user.destroy
      redirect_to root_path, notice: 'アカウントを削除しました。'
    else
      redirect_to root_path, alert: 'アカウント削除に失敗しました。'
    end
  end

  private

  # ゲストログイン時に編集画面にアクセス制限
  def ensure_guest_user
    if current_user.guest_user?
      redirect_to mypage_user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end  

  # URL パラメータからユーザーを取得
  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:alert] = "ユーザーが見つかりません。"
      redirect_to root_path
    end
  end

  # 許可するパラメータを指定
  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end
end
