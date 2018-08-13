# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#start'

  resources :users, except: %i[index]
  resources :products do
    collection do
      get :searched_items
      get :seller_dashboard
    end
  end

  resources :cart_checkout, except: %i[show new create] do
    member do
      put :increment_cart_item_quantity
      put :decrement_cart_item_quantity
      delete :destroy_cart_item
    end
    collection do
      post :add_to_cart
      get :purchase
      get :order_history
    end
  end

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '*path' => 'application#not_found'
end
