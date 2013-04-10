Inmuniversia::Application.routes.draw do

  devise_for :subscribers

  devise_for :users

  resources :vaccines, path: "/my_vaccines"

  root :to => "vaccines#index"

  mount Refinery::Core::Engine, :at => '/'

end
