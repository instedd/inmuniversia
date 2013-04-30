Inmuniversia::Application.routes.draw do

  # Refinery administrators
  devise_for :users

  # Application users
  devise_for :subscribers, controllers: {
    registrations: 'subscribers/registrations'
  }

  devise_scope :subscriber do
    get '/subscribers/mobile_configuration' => 'subscribers/registrations#mobile_configuration'
    post '/subscribers/add_mobile_number_and_send_verification_code' => 'subscribers/registrations#add_mobile_number_and_send_verification_code'
    post '/subscribers/submit_verification_code' => 'subscribers/registrations#submit_verification_code'
  end

  # Hide vaccine and disease resources from refinery and handle them manually
  resources :diseases, only: [:show, :index], path: '/vaccines/diseases'
  resources :vaccines, only: [:show, :index]

  resources :children, only: :create

  resources :channel_emails, only: [:create, :update, :destroy]

  resources :vaccinations, only: :update

  # Update preferences for a subscriber
  put '/settings/preferences' => 'settings#update_preferences', as: 'preferences'

  # Home page for logged in subscribers
  get '/dashboard' => 'dashboard#index', as: 'dashboard'

  root :to => "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
