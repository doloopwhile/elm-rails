require 'rails'

module Elm
  module Rails
    class Railtie < ::Rails::Railtie
      config.elm = ActiveSupport::OrderedOptions.new

      initializer 'elm_rails.setup_view_helpers', group: :all do
        ActiveSupport.on_load :action_view do
          include ::Elm::Rails::ViewHelper
        end
      end

      initializer 'elm_rails.add_component_renderer', group: :all do
        ActionController::Renderers.add :elm do |name, options|
          name = name.capitalize
          port = options.delete(:port) || {}

          options[:html] = self.class.helpers.elm_embed_tag(name, port, options)
          render(options)
        end
      end
    end
  end
end
