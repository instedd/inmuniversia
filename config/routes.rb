Inmuniversia::Application.routes.draw do

  devise_for :subscribers # Application users
  devise_for :users       # Refinery administrators

  resources :children

  resources :channel_emails, only: [:create, :update, :destroy]

  get '/dashboard' => 'dashboard#index', as: 'dashboard'

  root :to => "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
