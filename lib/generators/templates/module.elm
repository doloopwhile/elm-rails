module <%= file_name.to_s.capitalize %> where

import Html exposing (..)

main =
  text "<%= "app/assets/javascript/elm-modules/#{file_name}.elm" %>"
