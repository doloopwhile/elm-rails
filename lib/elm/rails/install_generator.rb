module Elm
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path '../templates', __FILE__

      desc 'Create default app/elm directory, elm_controller and route'

      def create_directory
        empty_directory 'elm'
      end

      def create_elm_package_json
        copy_file 'elm-package.json', 'elm/elm-package.json'
      end

      def create_elm_controller
        create_file 'elm_controller.rb', 'app/controllers/elm_controller.rb'
      end

      def add_routes
        route %q(get 'elm.js')
      end
    end
  end
end
