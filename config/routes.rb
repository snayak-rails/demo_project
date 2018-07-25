Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :products
  resources :carts
  resources :cart_items

  resources :cart_items do
    member do
      post :create_cart_item
    end
  end

  root 'application#start'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/seller_dashboard' => 'products#seller_dashboard'

  get '*path' => 'products#index'
end
