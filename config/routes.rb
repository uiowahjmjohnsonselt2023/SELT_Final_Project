Rails.application.routes.draw do
  # Root path (homepage)
  root 'home#index'

  # User authentication routes
  get 'signup', to: 'users#new'
  post 'users', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  # User routes for new, create, show, edit, update
  resources :users, only: [:new, :create, :show, :edit, :update]
  get '/profile/:id', to: 'users#show'


  # Item routes for creating, showing, editing, updating, and deleting item listings
  resources :items, only: [:new, :create, :show, :edit, :update, :destroy]
  get 'sell', to: 'items#new'
  get 'item', to: 'items#show'

  # Search route for searching items with optional category filtering
  get 'search', to: 'search#index'

  resources :categories, only: [:index, :show]

  resources :bookmarks, only: [:create, :destroy]

end
