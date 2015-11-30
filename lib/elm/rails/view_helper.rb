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

      def make_elm(dir_path, output_filename)
        Dir.chdir(dir_path) do
          elm_files = Dir.glob('**/*.elm').reject { |p| p.start_with?('elm-stuff/') }
          cmd = Shellwords.join([elm_executable_path, 'make'] + elm_files + ['--yes', '--output', output_filename])
          out, err, status = Open3.capture3(cmd)
          ::Rails.logger.debug(out)
          ::Rails.logger.error(err)
          fail err unless status.success?
        end
        # render file: File.join(dir_path, output_filename)
        File.read(File.join(dir_path, output_filename))
      end

      private

      def elm_executable_path
        path = ::Rails.application.config.elm.executable
        path || File.expand_path('../../js/elm/binwrappers/elm', __FILE__)
      end
    end
  end
end
