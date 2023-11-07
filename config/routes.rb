Rails.application.routes.draw do
  # Root path (homepage)
  root 'home#index'

  # User routes for new, create, show, edit, update
  resources :users, only: [:new, :create, :show, :edit, :update]

  # Session routes for login and logout
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Item routes for creating, showing, editing, updating, and deleting item listings
  resources :items

  # Search route for searching items with optional category filtering
  get 'search', to: 'search#index', as: 'search'

end
