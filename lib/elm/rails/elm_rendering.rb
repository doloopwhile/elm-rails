require 'open3'

module Elm
  module Rails
    module ElmRendering
      def render_elm_js(dir_path)
        elm_make(dir_path, 'elm.js')
        render file: File.join(dir_path, 'elm.js')
      end

      def render_elm_html(dir_path)
        elm_make(dir_path, 'elm.html')
        render html: make_elm(dir_path, 'elm.html')
      end

      private

      def elm_make(dir_path, output_filename)
        return unless recompile_required

        Dir.chdir(dir_path) do
          elm_files = Dir.glob('**/*.elm').reject { |p| p.start_with?('elm-stuff/') }
          cmd = Shellwords.join([elm_executable_path, 'make'] + elm_files + ['--yes', '--output', output_filename])
          out, err, status = Open3.capture3(cmd)
          ::Rails.logger.debug(out)
          ::Rails.logger.error(err)
          fail err unless status.success?
        end
      end

      def recompile_required
        debug = ::Rails.application.config.elm.debug
        return debug unless debug.nil?
        !(::Rails.env.production?)
      end

      def elm_executable_path
        path = ::Rails.application.config.elm.executable
        path || File.expand_path('../../js/elm/binwrappers/elm', __FILE__)
      end
    end
  end
end
