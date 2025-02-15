class User < ApplicationRecord
  # Devise モジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # アクティブストレージ
  has_one_attached :profile_image

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # メソッド
  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [width, height]).processed
    else
      ActionController::Base.helpers.asset_path('no_image.jpg')
    end
  end
  

  # フォロー数カウント
  def following_count
    following.size
  end

  def followers_count
    followers.size
  end

  # フォローしているか確認するメソッド
  def following?(other_user)
    following.include?(other_user)
  end

  # フォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # フォローを解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 検索方法分岐
  def self.looks(search, word)
    return User.none if word.blank?  # 空ワードの場合は結果なし
    
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  # ゲストログイン
  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  def guest_user?
    email == "guest@example.com"
  end
end
