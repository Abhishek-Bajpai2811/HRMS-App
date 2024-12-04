Rails.application.routes.draw do
  get "issued_items/index"
  get "issued_items/show"
  get "issued_items/new"
  get "issued_items/create"
  get "issued_items/edit"
  get "issued_items/update"
  get "issued_items/destroy"
  get "items/index"
  get "items/show"
  get "items/new"
  get "items/create"
  get "items/edit"
  get "items/update"
  get "items/destroy"
  # get '/auth/:provider/callback', to: 'users/sessions#omniauth'
  # get '/auth/failure',  to: 'users/sessions#failure'
  get '/auth/:provider/callback', to: 'users/omniauth_callbacks#google_oauth2'
  get '/auth/failure', to: 'users/omniauth_callbacks#failure'
  
  
  # get '/auth/:provider', to: 'sessions#passthru', as: :auth_passthru

 


  # Configure Devise routes with custom controllers
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Admin Routes
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # HR Routes
  namespace :hr do
    resources :documents, only: [:index, :edit]
  end

  # Standard Employee Routes
  resources :employees  # Use resources here for CRUD actions like edit, show, destroy

  # Employee Profile Route (if needed)
  namespace :employees do
    resource :profile, only: [:show]  # This seems like a profile page for the employee, not the full CRUD actions
  end

  # Custom Devise scope for logout (if required)
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # Root route
  root 'home#index'
 

  # Standard RESTful resources
  resources :documents
  resources :users, only: [:index, :show]

  resources :items
  resources :issued_items


 


  # Public pages routes
  get 'about', to: 'pages#about_us'
  get 'contact', to: 'pages#contact_us'
  get 'privacy-policy', to: 'pages#privacy_policy'
  get 'terms-and-conditions', to: 'pages#terms_and_conditions'
end