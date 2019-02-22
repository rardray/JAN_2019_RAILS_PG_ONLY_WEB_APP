Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  get 'like/create'
  get 'like/destroy'
  get 'comment/destroy'
  get 'comment/create'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/contact', to: 'static_pages#contact'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'static_pages#home'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy, :show] do
    member do
      get :likes
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
end
