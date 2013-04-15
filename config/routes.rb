Inmuniversia::Application.routes.draw do

  devise_for :subscribers

  devise_for :users

  # resources :vaccines, path: "/my_vaccines"

  resources :children

  root :to => "refinery/vaccines/vaccines#index"

  mount Refinery::Core::Engine, :at => '/'

end
