class UsersController < ApplicationController
  before_action :authenticate_user! # ログインしていないユーザーを弾く
  before_action :set_user, only: [:show, :edit, :update] # ユーザー情報を事前に取得

   # マイページ
  def mypage
    @user = current_user # ログイン中のユーザー情報を取得
  end

  # ユーザー詳細ページ
  def show
    @user
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

  # URL パラメータからユーザーを取得
  def set_user
    @user = User.find(params[:id])
  end

  # 許可するパラメータを指定
  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end
end
