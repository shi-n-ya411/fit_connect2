class CommentsController < ApplicationController
  before_action :authenticate_user! # ログイン必須

  def create
    @post = Post.find(params[:post_id]) # 対象の投稿を取得
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user # コメントの作成者を設定

    if @comment.save
      redirect_to post_path(@post), notice: "コメントを投稿しました。"
    else
      redirect_to post_path(@post), alert: "コメントを投稿できませんでした。"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user || current_user.admin? # 管理者または投稿者のみ削除可能
      @comment.destroy
      redirect_to post_path(@comment.post), notice: "コメントを削除しました。"
    else
      redirect_to post_path(@comment.post), alert: "コメントを削除できません。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
