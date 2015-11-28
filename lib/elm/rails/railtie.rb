require 'elm/rails'

module Elm
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_initialize do
        require 'elm/rails/template'
        require 'sprockets'
        Sprockets.register_engine '.elm', Elm::Rails::Template
      end

      initializer 'elm_rails.setup_view_helpers', group: :all do
        ActiveSupport.on_load(:action_view) do
          include ::Elm::Rails::ViewHelper
        end
      end
    end
  end
end
