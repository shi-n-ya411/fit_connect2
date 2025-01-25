class SearchesController < ApplicationController
  def search
    word = params[:word]
    range = params[:range]

    # 検索ワードが空でないか確認
    if word.blank?
      flash[:error] = "検索ワードを入力してください。"
      redirect_back(fallback_location: root_path) and return
    end

    # 範囲が「User」または「Post」のいずれかであることを確認
    unless ["User", "Post"].include?(range)
      flash[:error] = "無効な検索範囲です。"
      redirect_back(fallback_location: root_path) and return
    end

    # 検索処理
    if range == "User"
      @results = User.looks(params[:search], word)
    elsif range == "Post"
      @results = Post.looks(params[:search], word)
    else
      @results = []
    end
  end
end

