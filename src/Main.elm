module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main : Program () Int Msg
main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type Msg = Increment | Decrement

init : () -> (Int, Cmd Msg)
init _ = (0, Cmd.none)

update : Msg -> number -> (number, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)

    Decrement ->
      (model - 1, Cmd.none)

subscriptions : Int -> Sub Msg
subscriptions _ = Sub.none

view : Int -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
