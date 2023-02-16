module Main exposing (..)

import Browser
import Date exposing (Date, fromIsoString, format, fromCalendarDate, toIsoString)
import Time exposing (Month(..))
import Html exposing (Html, div, text, h1, ol, li, h2, p, input, pre, label)
import Html.Attributes as Attr
import Html.Events exposing (onInput)
import String.Format
import Task

firstPackageDate = fromCalendarDate 2005 Apr 18

type alias PyVersion = (Int, Int, Int)
type alias Model = { date : Result String Date
                   , version : Maybe PyVersion
                   , today : Date
                   }

-- from https://en.wikipedia.org/wiki/History_of_Python
pythonVersions =
  [ { version = (0, 9,  0), latestMicroVersion = (0, 9,  9),  releaseDate = fromIsoString "1991-02-20", endOfSupport = fromIsoString "1993-07-29" }
  , { version = (1, 0,  0), latestMicroVersion = (1, 0,  4),  releaseDate = fromIsoString "1994-01-26", endOfSupport = fromIsoString "1994-02-15" }
  , { version = (1, 1,  0), latestMicroVersion = (1, 1,  1),  releaseDate = fromIsoString "1994-10-11", endOfSupport = fromIsoString "1994-11-10" }
  , { version = (1, 2,  0), latestMicroVersion = (1, 2,  0),  releaseDate = fromIsoString "1995-04-13", endOfSupport = fromIsoString "1995-04-13" }
  , { version = (1, 3,  0), latestMicroVersion = (1, 3,  0),  releaseDate = fromIsoString "1995-10-13", endOfSupport = fromIsoString "1995-10-13" }
  , { version = (1, 4,  0), latestMicroVersion = (1, 4,  0),  releaseDate = fromIsoString "1996-10-25", endOfSupport = fromIsoString "1996-10-25" }
  , { version = (1, 5,  0), latestMicroVersion = (1, 5,  2),  releaseDate = fromIsoString "1998-01-03", endOfSupport = fromIsoString "1999-04-13" }
  , { version = (1, 6,  0), latestMicroVersion = (1, 6,  1),  releaseDate = fromIsoString "2000-09-05", endOfSupport = fromIsoString "2000-09-01" }
  , { version = (2, 0,  0), latestMicroVersion = (2, 0,  1),  releaseDate = fromIsoString "2000-10-16", endOfSupport = fromIsoString "2001-06-22" }
  , { version = (2, 1,  0), latestMicroVersion = (2, 1,  3),  releaseDate = fromIsoString "2001-04-15", endOfSupport = fromIsoString "2002-04-09" }
  , { version = (2, 2,  0), latestMicroVersion = (2, 2,  3),  releaseDate = fromIsoString "2001-12-21", endOfSupport = fromIsoString "2003-05-30" }
  , { version = (2, 3,  0), latestMicroVersion = (2, 3,  7),  releaseDate = fromIsoString "2003-06-29", endOfSupport = fromIsoString "2008-03-11" }
  , { version = (2, 4,  0), latestMicroVersion = (2, 4,  6),  releaseDate = fromIsoString "2004-11-30", endOfSupport = fromIsoString "2008-12-19" }
  , { version = (2, 5,  0), latestMicroVersion = (2, 5,  6),  releaseDate = fromIsoString "2006-09-19", endOfSupport = fromIsoString "2011-05-26" }
  , { version = (2, 6,  0), latestMicroVersion = (2, 6,  9),  releaseDate = fromIsoString "2008-10-01", endOfSupport = fromIsoString "2010-08-24" }
  , { version = (2, 7,  0), latestMicroVersion = (2, 7,  18), releaseDate = fromIsoString "2010-07-03", endOfSupport = fromIsoString "2020-01-01" }
  , { version = (3, 0,  0), latestMicroVersion = (3, 0,  1),  releaseDate = fromIsoString "2008-12-03", endOfSupport = fromIsoString "2009-06-27" }
  , { version = (3, 1,  0), latestMicroVersion = (3, 1,  5),  releaseDate = fromIsoString "2009-06-27", endOfSupport = fromIsoString "2011-06-12" }
  , { version = (3, 2,  0), latestMicroVersion = (3, 2,  6),  releaseDate = fromIsoString "2011-02-20", endOfSupport = fromIsoString "2013-05-13" }
  , { version = (3, 3,  0), latestMicroVersion = (3, 3,  7),  releaseDate = fromIsoString "2012-09-29", endOfSupport = fromIsoString "2014-03-08" }
  , { version = (3, 4,  0), latestMicroVersion = (3, 4,  10), releaseDate = fromIsoString "2014-03-16", endOfSupport = fromIsoString "2017-08-09" }
  , { version = (3, 5,  0), latestMicroVersion = (3, 5,  10), releaseDate = fromIsoString "2015-09-13", endOfSupport = fromIsoString "2017-08-08" }
  , { version = (3, 6,  0), latestMicroVersion = (3, 6,  15), releaseDate = fromIsoString "2016-12-23", endOfSupport = fromIsoString "2018-12-24" }
  , { version = (3, 7,  0), latestMicroVersion = (3, 7,  16), releaseDate = fromIsoString "2018-06-27", endOfSupport = fromIsoString "2020-06-27" }
  , { version = (3, 8,  0), latestMicroVersion = (3, 8,  16), releaseDate = fromIsoString "2019-10-14", endOfSupport = fromIsoString "2021-05-03" }
  , { version = (3, 9,  0), latestMicroVersion = (3, 9,  16), releaseDate = fromIsoString "2020-10-05", endOfSupport = fromIsoString "2022-05-17" }
  , { version = (3, 10, 0), latestMicroVersion = (3, 10, 10), releaseDate = fromIsoString "2021-10-04", endOfSupport = fromIsoString "2023-05-01" }
  , { version = (3, 11, 0), latestMicroVersion = (3, 11, 2),  releaseDate = fromIsoString "2022-10-24", endOfSupport = fromIsoString "2024-05-01" }
  , { version = (3, 12, 0), latestMicroVersion = (3, 12, 0),  releaseDate = fromIsoString "2023-10-02", endOfSupport = fromIsoString "2025-05-01" }
  ]

initialModel : Model
initialModel =
  { date = Err "No date selected"
  , version = Just (2, 7, 0)
  , today = fromCalendarDate 2019 Jan 1
  }

main : Program () Model Msg
main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type Msg = SetWorkingDate String
         | SetTodayDate Date

init : () -> (Model, Cmd Msg)
init _ = (initialModel, Date.today |> Task.perform SetTodayDate)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetWorkingDate d ->
      ({ model | date = fromIsoString d }, Cmd.none)
    SetTodayDate d ->
      ({ model | today = d }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

toRetroPipUrl : Date -> String
toRetroPipUrl d = "https://retropip.com/" ++ (format "yyyy/MM/dd" d) ++ "/simple"


versionToString : PyVersion -> String
versionToString version = 
  let
    (major, minor, patch) = version
  in
    "{{ major }}.{{ minor }}.{{ patch }}"
      |> String.Format.namedValue "major" (String.fromInt major)
      |> String.Format.namedValue "minor" (String.fromInt minor)
      |> String.Format.namedValue "patch" (String.fromInt patch)

dockerRecipe : Date -> PyVersion -> Html Msg
dockerRecipe date version =
  let
    template = """
FROM python/{{ version }}

WORKDIR /usr/src/app

COPY requirements.txt ./
ENV PIP_INDEX_URL="{{ indexUrl }}"
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-script.py" ]
  """
  in
    pre [] [ text ( template
                      |> String.Format.namedValue "indexUrl" (toRetroPipUrl date)
                      |> String.Format.namedValue "version" (versionToString version))
            ]

viewRecipe : Model -> Html Msg
viewRecipe model =
  let
    { date, version } = model
  in
    case (date, version) of
      (Ok d, Just v) -> dockerRecipe d v
      _ -> text ""

intro : Html Msg
intro = 
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
    ]

workingDateSelector : Model -> Html Msg
workingDateSelector model =
  div []
    [ label [ Attr.for "lastWorkingDate" ] [ text "Last working date:" ]
    , input [ Attr.type_ "date"
            , Attr.id "lastWorkingDate"
            , Attr.name "lastWorkingDate"
            , Attr.min <| toIsoString firstPackageDate
            , Attr.max <| toIsoString model.today
            , (onInput SetWorkingDate)
            ] [  ]
    ]

view : Model -> Html Msg
view model =
  div []
    [ intro
    , workingDateSelector model
    , viewRecipe model
    ]
