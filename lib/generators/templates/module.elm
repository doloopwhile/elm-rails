module <%= file_name %>

import Html exposing (text)

main =
  text "<%= "app/assets/javascript/elm-modules/#{file_name}.elm" %>"
