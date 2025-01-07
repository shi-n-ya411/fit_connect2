Rails.application.routes.draw do

  # Devise のルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # ルートと静的ページ
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  # ユーザーマイページ
  get 'mypage', to: 'users#mypage', as: 'mypage_users'

  # ユーザー関連のルート
  resources :users, only: [:index, :show, :destroy]

  # 投稿関連のルート
  resources :posts

end

