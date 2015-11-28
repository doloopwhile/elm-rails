require 'elm/rails'
require 'tilt/template'
require 'open3'

module Elm
  module Rails
    class Template < ::Tilt::Template
      self.default_mime_type = 'application/javascript'

      def evaluate(context, locals, &block)
        if @output
          return @output
        end

        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            elm_name = File.basename(file).capitalize
            js_name = "#{name}.js"

            FileUtils.copy(file, elm_name)
            File.write 'elm-package.json', <<-EOS
{
    "version": "1.0.0",
    "summary": "helpful summary of your project, less than 80 characters",
    "repository": "https://github.com/USER/PROJECT.git",
    "license": "BSD3",
    "source-directories": [
        "."
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "2.1.0 <= v < 3.0.0",
        "evancz/elm-html": "3.0.0 <= v < 5.0.0"
    },
    "elm-version": "0.15.1 <= v < 0.16.0"
}
            EOS
            out, err, status = Open3.capture3("elm make #{elm_name} --yes --output #{js_name}")
            Rails.logger.info(out)
            Rails.logger.warn(err)
            unless status.success?
              fail err
            end
            @output = File.read(js_name)
          end
        end
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
    end
  end
end
