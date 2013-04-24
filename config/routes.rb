Inmuniversia::Application.routes.draw do

  # Refinery administrators
  devise_for :users

  # Application users
  devise_for :subscribers, controllers: {
    registrations: 'subscribers/registrations'
  }

  # Hide vaccine and disease resources from refinery and handle them manually
  resources :diseases, only: [:show, :index], path: '/vaccines/diseases'
  resources :vaccines, only: [:show, :index]
  
  resources :children, only: :create

  resources :channel_emails, only: [:create, :update, :destroy]

  # Home page for logged in subscribers
  get '/dashboard' => 'dashboard#index', as: 'dashboard'

  root :to => "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
