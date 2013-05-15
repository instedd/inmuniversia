module Refinery
  module Vaccines
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Vaccines

      engine_name :refinery_vaccines

      initializer "register refinerycms_diseases plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "diseases"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.vaccines_admin_diseases_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/vaccines/disease',
            :title => 'name'
          }
          plugin.menu_match = %r{refinery/vaccines/diseases(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Diseases)
      end
    end
  end
end
