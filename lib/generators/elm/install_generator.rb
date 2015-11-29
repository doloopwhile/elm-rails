module Elm
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path '../../templates', __FILE__

      desc 'Create default elm.js folder layout and prep application.js'

      class_option(
        :skip_git,
        type: :boolean,
        aliases: '-g',
        default: false,
        desc: 'Skip Git keeps'
      )

      def create_directory
        empty_directory 'app/assets/javascripts/elm-modules'
        create_file 'app/assets/javascripts/elm-modules/.gitkeep' unless options[:skip_git]
      end

      def inject_elm_modules_js
        require_elm = "//= require elm-modules\n"

        unless manifest.exist?
          create_file manifest, require_elm
          return
        end

        manifest_contents = File.read(manifest)

        if manifest_contents.include? 'require turbolinks'
          inject_into_file manifest, require_elm, after: "//= require turbolinks\n"
          return
        end

        if manifest_contents.include? 'require_tree'
          require_tree = manifest_contents.match(%r{//= require_tree[^\n]*})[0]
          inject_into_file manifest, require_elm, before: require_tree
          return
        end

        append_file manifest, require_elm
      end

      def create_elm_modules_js
        copy_file 'elm-modules.js', 'app/assets/javascripts/elm-modules.js'
      end

      def create_elm_package_json
        copy_file 'elm-package.json', 'config/elm-package.json'
      end

      private

      def manifest
        Pathname.new(destination_root).join('app/assets/javascripts', 'application.js')
      end
    end
  end
end
