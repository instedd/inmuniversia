Inmuniversia::Application.routes.draw do

  devise_for :subscribers

  devise_for :users

  resources :children

  root :to => "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
