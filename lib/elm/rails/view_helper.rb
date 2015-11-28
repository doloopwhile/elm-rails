module Elm
  module Rails
    module ViewHelper
      def elm_embed(name, options = {}, &block)
        options = { tag: options } if options.is_a?(Symbol)
        name = name.capitalize

        html_options = options.reverse_merge(data: {})
        html_options[:data].tap do |data|
          data[:elm_module] = name
        end
        html_tag = html_options.delete(:tag) || :div

        content_tag(html_tag, '', html_options, &block)
      end

      def elm_fullscreen(name)
        name = name.capitalize
        javascript_tag "Elm.fullscreen(Elm.#{name})"
      end
    end
  end
end
