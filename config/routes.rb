Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  get '/contact', to: 'static_pages#contact'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  root 'static_pages#home'
  resources :users
end
