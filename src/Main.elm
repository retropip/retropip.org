module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, h1, ol, li, br, h2, p)
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
    [ h1 [ ] [ text "Welcome to retropip.com!" ]
    , p [] [ text "Your old Python projects don't have to die!" ]
    , p [] [ text "At retropip.com, we know how frustrating it can be when outdated dependencies and tools prevent your code from running. That's why we've created a platform that makes it easy for Python developers to revive old programs and keep them running smoothly." ]
    , p [] [ text "Join us and never let your old Python programs fade away!" ]
    , h2 [] [ text "How it works?" ]
    , ol [] [ li [ ] [ text "Tell us the approximate date when you know for sure that your program was able to install and run. This will help us determine the appropriate Python version and dependencies needed to run your program." ]
            , li [ ] [ text "We will generate a recipe that includes the specific Python version and a special PyPI index that reflects the dependencies available at that time." ]
            , li [ ] [ text "Use the recipe to build your program in a Docker container or a virtualenv. This will ensure that your program has access to the correct dependencies and can run smoothly." ]
            , li [ ] [ text "Test your program and make any necessary updates or changes to ensure that it works as intended." ]
            , li [ ] [ text "Sit back and enjoy the peace of mind that comes with knowing your old Python program is running smoothly again!" ]
            ]
    , button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
