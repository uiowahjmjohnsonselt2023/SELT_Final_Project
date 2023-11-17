Rails.application.routes.draw do
  # Root path (homepage)
  root 'home#index'

  # User authentication routes
  get 'signup', to: 'users#new'
  post 'users', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # User routes for new, create, show, edit, update
  resources :users, only: [:new, :create, :show, :edit, :update]
  get 'profile', to: 'users#show'


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

  resources :bookmarks, only: [:create, :destroy]

end
