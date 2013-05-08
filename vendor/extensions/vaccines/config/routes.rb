Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :vaccines do
    resources :diseases, :only => [:index, :show]
  end

  # Admin routes
  namespace :vaccines, :path => '' do
    namespace :admin, :path => 'refinery/vaccines' do
      resources :diseases, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

  # Frontend routes
  namespace :vaccines do
    resources :vaccines, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :vaccines, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :vaccines, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
