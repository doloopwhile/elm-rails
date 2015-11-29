require 'rails'
require 'elm/rails'
require 'tilt/template'
require 'open3'
require 'fileutils'

module Elm
  module Rails
    class Template < ::Tilt::Template
      self.default_mime_type = 'application/javascript'

      def prepare
      end

      def evaluate(context, locals, &block)
        return @output if @output

        build_dir = "#{::Rails.root}/tmp/elm-builds"
        FileUtils.mkdir_p(build_dir)

        Dir.chdir(build_dir) do
          elm_name = File.basename(file).capitalize
          js_name = "#{elm_name}.js"

          FileUtils.copy(file, elm_name)
          FileUtils.copy("#{::Rails.root}/config/elm-package.json", 'elm-package.json')

          out, err, status = Open3.capture3("#{elm_executable_path} make #{elm_name} --yes --output #{js_name}")
          ::Rails.logger.debug out
          ::Rails.logger.error err
          fail err unless status.success?
          @output = File.read(js_name)
        end

        @output
      end

      # @override
      def allows_script?
        false
      end

      def self.engine_initialized?
        defined? ::Elm::Rails::Compiler
      end

      def initialize_engine
        require_template_library 'elm/rails/compiler'
      end

      private

      def elm_executable_path
        path = ::Rails.application.config.elm.executable
        path || File.expand_path('../../js/elm/binwrappers/elm', __FILE__)
      end
    end
  end
end
