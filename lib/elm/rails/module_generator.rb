module Elm
  module Generators
    class ModuleGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path '../templates', __FILE__

      desc 'Create default elm.js folder layout and prep application.js'

      def create_component_file
        file_path = File.join('app/assets/javascripts/elm-modules', "#{file_name}.elm")
        template('module.elm', file_path)
      end
    end
  end
end
