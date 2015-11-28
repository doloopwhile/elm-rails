module Elm
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path '../../templates', __FILE__

      desc 'Create default elm.js folder layout and prep application.js'

      class_option :skip_git,
        type: :boolean,
        aliases: '-g',
        default: false,
        desc: 'Skip Git keeps'

      def create_directory
        empty_directory 'app/assets/javascripts/elm-components'
        create_file 'app/assets/javascripts/elm-components/.gitkeep' unless options[:skip_git]
      end

      def inject_elm
        require_elm = "//= require elm\n"

        unless manifest.exist?
          create_file manifest, require_elm
          return
        end

        manifest_contents = File.read(manifest)

        if manifest_contents.include? 'require turbolinks'
          inject_into_file manifest, require_elm, {after: "//= require turbolinks\n"}
        elsif manifest_contents.include? 'require_tree'
          require_tree = manifest_contents.match(/\/\/= require_tree[^\n]*/)[0]
          inject_into_file manifest, require_elm, {before: require_tree}
        else
          append_file manifest, require_elm
        end
      end

      def inject_components
        inject_into_file manifest, "//= require elm-components\n", {after: "//= require elm\n"}
      end

      def create_components
        components_js = "//= require_tree ./elm-components\n"
        components_file = File.join(*%w(app assets javascripts elm-components.js))
        create_file components_file, components_js
      end

      private

      def manifest
        Pathname.new(destination_root).join('app/assets/javascripts', 'application.js')
      end
    end
  end
end
