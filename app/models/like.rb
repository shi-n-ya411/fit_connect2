class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id } # ユーザーごとに1つの投稿に1回だけ「いいね」できる
end
