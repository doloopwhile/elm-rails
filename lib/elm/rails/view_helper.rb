module Elm
  module Rails
    module ViewHelper
      def elm_embed_tag(name, port_values = {}, options = {}, &block)
        options = { tag: options } if options.is_a?(Symbol)
        name = name.capitalize

        html_options = options.reverse_merge(data: {})
        html_options[:data].tap do |data|
          data[:elm_module] = name
          data[:elm_port_values] = (port_values.is_a?(String) ? port_values : port_values.to_json)
        end
        html_tag = html_options.delete(:tag) || :div

        content_tag(html_tag, '', html_options, &block)
      end

      def elm_fullscreen_tag(name, port_values = {}, options = {}, &block)
        javascript_tag("Elm.fullscreen(Elm.#{name}, #{port_values.to_json})", options, &block)
      end

      private

      def elm_executable_path
        path = ::Rails.application.config.elm.executable
        path || File.expand_path('../../js/elm/binwrappers/elm', __FILE__)
      end
    end
  end
end
