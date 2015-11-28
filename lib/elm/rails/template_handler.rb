require 'elm/rails/compiler'

class Elm::Rails::TemplateHandler
  def call(template)
    'alert("hello")'
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::Template.register_template_handler :elm, Elm::Rails::TemplateHandler
end
