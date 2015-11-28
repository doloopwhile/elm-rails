require 'elm/rails'

class Elm::Rails::Railtie < ::Rails::Railtie
  config.before_initialize do |app|
    if app.config.assets.enabled
      require 'elm/rails/template'
      require 'sprockets'
      Sprockets.register_engine '.elm', Elm::Rails::Template
    end
  end
end
