Rails.application.routes.draw do
  #-------------------管理者-----------------------

  # Deviseのルート設定
  devise_for :admins, path: 'admins', skip: [:registrations], controllers: {
  sessions: 'admins/sessions'
  }

  # 管理者用リソース
  namespace :admin do
    resources :users, only: [:index, :destroy] # 管理者用ユーザー管理ページ
    resources :posts, only: [:index, :destroy] # 投稿管理ページ
    root to: 'dashboard#index' # 管理者用トップページ
  end

  #-------------------一般ユーザー-----------------------

  # Devise のルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  # ルートと静的ページ
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  # ユーザーマイページ
  get 'mypage', to: 'users#mypage', as: 'mypage_users'

  # ユーザー関連
  resources :users, only: [:index, :show, :destroy] do
    member do
      get :following, :followers # フォロー機能のルート
    end
  end

  # 投稿関連
  resources :posts do
    resources :comments, only: [:create, :destroy] # コメント機能
    resource :like, only: [:create, :destroy] # いいね機能
    collection do
      get :liked # `/posts/liked` でアクセスできるようにする
    end
  end

  # フォロー機能
  resources :relationships, only: [:create, :destroy]
  resources :users do
    member do
      get :following
      get :followers
    end
  end

   # 検索機能
    get "search", to: "searches#search"

end


