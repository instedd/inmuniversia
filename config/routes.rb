Inmuniversia::Application.routes.draw do

  devise_for :users       # Refinery administrators

  resources :children, only: :create

  resources :channel_emails, only: [:create, :update, :destroy]

  # Application users
  devise_for :subscribers, controllers: {
    registrations: 'subscribers/registrations'
  }

  get '/dashboard' => 'dashboard#index', as: 'dashboard'

  root :to => "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
