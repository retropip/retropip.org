module Main exposing (..)

import Browser
import Date exposing (Date, Interval(..), Unit(..), fromIsoString, format)
import Html exposing (Html, div, text, h1, ol, li, h2, p, input, pre)
import Html.Attributes as Attr
import Html.Events exposing (onInput)
import String.Format

type alias PyVersion = (Int, Int, Int)
type alias Model = { date : Result String Date
                   , version : Maybe PyVersion
                   }

initialModel : Model
initialModel = { date = Err "No date selected", version = Just (2, 7, 0) }

main : Program () Model Msg
main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type Msg = SetDate String

init : () -> (Model, Cmd Msg)
init _ = (initialModel, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetDate d ->
      ({ model | date = fromIsoString d }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

toRetroPipUrl : Date -> String
toRetroPipUrl d = "https://retropip.com/" ++ (format "yyyy/MM/dd" d) ++ "/simple"


dockerRecipe : Model -> Html Msg
dockerRecipe model =
  let
    {date, version} = model
    template = """
FROM python/{{ major }}.{{ minor }}.{{ patch }}

WORKDIR /usr/src/app

COPY requirements.txt ./
ENV PIP_INDEX_URL="{{ indexUrl }}"
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-script.py" ]
  """
  in
    case (date, version) of
      ( Ok d, Just (major, minor, patch)) ->
        pre [] [ text ( template
                          |> String.Format.namedValue "indexUrl" (toRetroPipUrl d)
                          |> String.Format.namedValue "major" (String.fromInt major)
                          |> String.Format.namedValue "minor" (String.fromInt minor)
                          |> String.Format.namedValue "patch" (String.fromInt patch))
                ]
      _ -> div [] []

view : Model -> Html Msg
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
    , input [ Attr.type_ "date"
            , (onInput SetDate)
            ] [  ]
    , dockerRecipe model
    ]
