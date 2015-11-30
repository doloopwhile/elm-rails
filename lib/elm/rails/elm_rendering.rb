require 'open3'

module Elm
  module Rails
    module ElmRendering
      def render_elm_js(dir_path)
        make_elm(dir_path, 'elm.js')
      end

      def render_elm_html(dir_path)
        make_elm(dir_path, 'elm.html')
      end

      private

      def make_elm(dir_path, output_filename)
        Dir.chdir(dir_path) do
          elm_files = Dir.glob('**/*.elm').reject { |p| p.start_with?('elm-stuff/') }
          cmd = Shellwords.join([elm_executable_path, 'make'] + elm_files + ['--yes', '--output', output_filename])
          out, err, status = Open3.capture3(cmd)
          ::Rails.logger.debug(out)
          ::Rails.logger.error(err)
          fail err unless status.success?
        end
        render file: File.join(dir_path, output_filename)
      end

      def elm_executable_path
        path = ::Rails.application.config.elm.executable
        path || File.expand_path('../../js/elm/binwrappers/elm', __FILE__)
      end
    end
  end
end
