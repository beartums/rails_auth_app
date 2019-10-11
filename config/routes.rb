Rails.application.routes.draw do
  get 'password_reset/new'
  get 'password_reset/edit'
  root 'static_pages#home'
  get 'sessions/new'
  get 'users/new'
  get '/help', to: 'static_pages#help'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets, only:[:edit, :new, :create, :update]
  resources :microposts, only:[:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end  
  resources :relationships, only:[:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
