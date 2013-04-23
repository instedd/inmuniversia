Inmuniversia::Application.routes.draw do

  devise_for :subscribers
  devise_for :users

  resources :children

  resources :channel_emails, only: [:create, :update, :destroy]

  root :to => "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
