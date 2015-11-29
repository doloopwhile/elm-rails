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
