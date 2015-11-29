module <%= file_name.camelize %> where

import Html exposing (..)

main =
  text "<%= "app/assets/javascript/elm-modules/#{file_name}.elm" %>"
