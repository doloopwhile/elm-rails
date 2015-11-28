require "bundler/gem_tasks"

namespace :elm do
  desc "Use NPM to install the elm executable"
  task :install do
    Dir.chdir("elm-builds") do
      `npm install`
    end
  end

  task :copy do
    FileUtils.cp(
      File.expand_path("../elm-builds/node_modules/.bin/elm", __FILE__),
      File.expand_path("../lib/elm/bin/elm", __FILE__)
    )
  end
end
