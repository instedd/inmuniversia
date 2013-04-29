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
