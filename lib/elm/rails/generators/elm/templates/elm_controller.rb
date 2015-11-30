class ElmController < ApplicationController
  include Elm::Rails::ElmRandering

  def elm_js
    render_elm_js "#{Rails.root}/elm/"
  end
end
