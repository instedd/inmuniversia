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

module Refinery
  module Vaccines
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Vaccines

      engine_name :refinery_vaccines

      initializer "register refinerycms_vaccines plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "vaccines"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.vaccines_admin_vaccines_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/vaccines/vaccine',
            :title => 'name'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Vaccines)
      end
    end
  end
end
