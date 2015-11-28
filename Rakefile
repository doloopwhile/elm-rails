require "bundler/gem_tasks"

namespace :elm do
  desc "Use NPM to install the elm executable"
  task :install do
    Dir.chdir("elm-builds") do
      `npm install`
    end
  end

  JS_DIR = File.expand_path("../lib/elm/js/", __FILE__)
  directory JS_DIR
  task :copy => JS_DIR do
    elm_dir = File.expand_path("../elm-builds/node_modules/elm", __FILE__)
    sh %Q(cp -r "#{elm_dir}" "#{JS_DIR}")
  end
end
