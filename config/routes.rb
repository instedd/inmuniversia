Inmuniversia::Application.routes.draw do

  # Refinery administrators
  devise_for :users

  # Application users
  devise_for :subscribers, controllers: {
    registrations: 'subscribers/registrations',
    sessions: 'subscribers/sessions',
    passwords: 'subscribers/passwords'
  }

  devise_scope :subscriber do
    get '/subscribers/mobile_configuration' => 'subscribers/registrations#mobile_configuration'
    post '/subscribers/add_mobile_number_and_send_verification_code' => 'subscribers/registrations#add_mobile_number_and_send_verification_code'
    post '/subscribers/submit_verification_code' => 'subscribers/registrations#submit_verification_code'
    get '/subscribers/subscriber_from_mobile' => 'subscribers/registrations#subscriber_from_mobile'
    post '/subscribers/find_subscriber_and_send_verification_code' => 'subscribers/registrations#find_subscriber_and_send_verification_code'
    post '/subscribers/submit_verification_code_and_fulfill_user_data' => 'subscribers/registrations#submit_verification_code_and_fulfill_user_data'
    put '/subscribers/update_sms_user' => 'subscribers/registrations#update_sms_user'
    get '/subscribers/edit' => 'subscribers/registrations#edit'
    put '/subscribers/update' => 'subscribers/registrations#update'
  end

  # Hide vaccine and disease resources from refinery and handle them manually
  resources :diseases, only: [:show, :index], path: '/vaccines/diseases'
  resources :vaccines, only: [:show, :index]

  # Application resources
  resources :children,        only: [:create, :destroy]
  resources :channel_emails,  only: [:create, :update, :destroy]
  resources :channel_sms,     only: [:create, :update, :destroy]
  resources :vaccinations,    only: :update
  resources :calendars,       only: :update

  resources :comments, :only => [:create, :destroy]
  put '/comments/load_form' => 'comments#load_form'

  # Update preferences for a subscriber
  put '/settings/preferences' => 'settings#update_preferences', as: 'preferences'

  # Home page for logged in subscribers
  get '/dashboard' => 'dashboard#index', as: 'dashboard'

  # Initial home page
  get '/home' => 'home#index', as: 'home'

  post '/nuntium/receive_at' => 'nuntium#receive_at'

  # Root pages
  authenticated :subscriber do
    root to: "dashboard#index"
  end

  root to: "home#index"

  mount Refinery::Core::Engine, :at => '/'

end
