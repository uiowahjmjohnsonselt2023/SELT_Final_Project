Rails.application.routes.draw do
  # Root path (homepage)
  root 'home#index'

  # User authentication routes
  get 'signup', to: 'users#new'
  post 'users', to: 'users#create'
  delete 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  post 'users/:id/add_payment_method', to: 'users#add_payment_method', as: 'add_payment_method_user'
  post 'users/:id/add_address', to: 'users#add_address', as: 'add_address_user'

  # User routes for new, create, show, edit, update

  resources :users, only: [:new, :create, :show, :edit, :update] do
    member do
      delete 'delete_address', to: 'users#delete_address'
      delete 'delete_payment_method', to: 'users#delete_payment_method'
    end
  end
  get '/profile/:id', to: 'users#show', as: 'profile'


  # Item routes for creating, showing, editing, updating, and deleting item listings
  resources :items, only: [:new, :create, :show, :edit, :update, :destroy]
  get 'sell', to: 'items#new'
  get 'item', to: 'items#show'

  # Checkout route for showing the checkout page
  #get 'checkout/:item_id', to: 'checkout#show', as: 'checkout_show'
  # Set up to handle the purchase of an item
  #post 'checkout/:id/purchase', to: 'checkout#purchase', as: 'checkout_purchase'

  resources :checkout, only: [:show] do
    member do
      post 'purchase'
    end
  end


  # Search route for searching items with optional category filtering
  get 'search', to: 'search#index'

  resources :categories, only: [:index, :show]

  resources :reviews, only: [:create, :destroy]

  resources :bookmarks, only: [:create, :destroy]

end
