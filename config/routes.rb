Rails.application.routes.draw do

  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  root to: 'homes#top'
  get 'about', to: 'homes#about'
  get 'mypage', to: 'users#mypage', as: 'mypage'
  # resources :users, only: [:show, :edit, :update, :destroy]

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    collection do
      get :mypage
    end
  end
  
  resources :post, only: [:new, :index, :show, :edit]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
