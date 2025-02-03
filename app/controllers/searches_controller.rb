class SearchesController < ApplicationController
  def search
    word = params[:word]

    # 検索ワードが空でないか確認
    if word.blank?
      flash[:error] = "検索ワードを入力してください。"
      redirect_back(fallback_location: root_path) and return
    end

    # ユーザー検索
    @users = User.where("name LIKE ?", "%#{word}%")

    # 投稿検索（タイトル or 内容）
    @posts = Post.where("title LIKE ? OR content LIKE ?", "%#{word}%", "%#{word}%")
  end
end
