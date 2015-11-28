module Elm
  module Rails
    module ViewHelper
      def elm_component(name, options = {}, &block)
        options = { tag: options } if options.is_a?(Symbol)
        name = name.capitalize

        html_options = options.reverse_merge(data: {})
        html_options[:data].tap do |data|
          data[:elm_module] = name
        end
        html_tag = html_options.delete(:tag) || :div

        content_tag(html_tag, '', html_options, &block)
      end
    end
  end
end
