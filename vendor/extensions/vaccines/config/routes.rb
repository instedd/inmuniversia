# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

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
