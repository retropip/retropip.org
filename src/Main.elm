module Main exposing (..)

import Browser
import Date exposing (Date, fromIsoString, format, fromCalendarDate, toIsoString)
import Time exposing (Month(..))
import Html exposing (Html, div, text, h1, ol, li, h2, p, input, pre, label, select, option)
import Html.Attributes as Attr
import Html.Events exposing (onInput)
import String.Format
import Task
import Maybe.Extra as ME

firstPackageDate : Date
firstPackageDate = fromCalendarDate 2005 Apr 18

type alias PythonVersion = (Int, Int, Int)

type alias Model =
  { date : Result String Date
  , distribution : Maybe Distribution
  , today : Date
  }

type PythonInterpreter = CPython

interpreterToString : PythonInterpreter -> String
interpreterToString _ = "CPython"

type alias Distribution = 
  { interpreter : PythonInterpreter
  , version : PythonVersion
  , latestMicroVersion : PythonVersion
  , releaseDate : Date
  , endOfSupport : Date
  , dockerImage : Maybe String
  , pyenvAvailable : Bool
  }


-- -- from podman search `podman search library/python --list-tags --no-trunc --limit 10000`
-- Just "docker.io/library/python:2.7.10"
-- Just "docker.io/library/python:2.7.11"
-- Just "docker.io/library/python:2.7.12"
-- Just "docker.io/library/python:2.7.13"
-- Just "docker.io/library/python:2.7.14"
-- Just "docker.io/library/python:2.7.15"
-- Just "docker.io/library/python:2.7.16"
-- Just "docker.io/library/python:2.7.17"
-- Just "docker.io/library/python:2.7.18"
-- Just "docker.io/library/python:2.7.7"
-- Just "docker.io/library/python:2.7.8"
-- Just "docker.io/library/python:2.7.9"
-- Just "docker.io/library/python:3.10.0"
-- Just "docker.io/library/python:3.10.1"
-- Just "docker.io/library/python:3.10.10"
-- Just "docker.io/library/python:3.10.2"
-- Just "docker.io/library/python:3.10.3"
-- Just "docker.io/library/python:3.10.4"
-- Just "docker.io/library/python:3.10.5"
-- Just "docker.io/library/python:3.10.6"
-- Just "docker.io/library/python:3.10.7"
-- Just "docker.io/library/python:3.10.8"
-- Just "docker.io/library/python:3.10.9"
-- Just "docker.io/library/python:3.11.0"
-- Just "docker.io/library/python:3.11.1"
-- Just "docker.io/library/python:3.11.2"
-- Just "docker.io/library/python:3.2.6"
-- Just "docker.io/library/python:3.3.5"
-- Just "docker.io/library/python:3.3.6"
-- Just "docker.io/library/python:3.3.7"
-- Just "docker.io/library/python:3.4.1"
-- Just "docker.io/library/python:3.4.10"
-- Just "docker.io/library/python:3.4.2"
-- Just "docker.io/library/python:3.4.3"
-- Just "docker.io/library/python:3.4.4"
-- Just "docker.io/library/python:3.4.5"
-- Just "docker.io/library/python:3.4.6"
-- Just "docker.io/library/python:3.4.7"
-- Just "docker.io/library/python:3.4.8"
-- Just "docker.io/library/python:3.4.9"
-- Just "docker.io/library/python:3.5.0"
-- Just "docker.io/library/python:3.5.1"
-- Just "docker.io/library/python:3.5.10"
-- Just "docker.io/library/python:3.5.2"
-- Just "docker.io/library/python:3.5.3"
-- Just "docker.io/library/python:3.5.4"
-- Just "docker.io/library/python:3.5.5"
-- Just "docker.io/library/python:3.5.6"
-- Just "docker.io/library/python:3.5.7"
-- Just "docker.io/library/python:3.5.8"
-- Just "docker.io/library/python:3.5.9"
-- Just "docker.io/library/python:3.6.0"
-- Just "docker.io/library/python:3.6.1"
-- Just "docker.io/library/python:3.6.10"
-- Just "docker.io/library/python:3.6.11"
-- Just "docker.io/library/python:3.6.12"
-- Just "docker.io/library/python:3.6.13"
-- Just "docker.io/library/python:3.6.14"
-- Just "docker.io/library/python:3.6.15"
-- Just "docker.io/library/python:3.6.2"
-- Just "docker.io/library/python:3.6.3"
-- Just "docker.io/library/python:3.6.4"
-- Just "docker.io/library/python:3.6.5"
-- Just "docker.io/library/python:3.6.6"
-- Just "docker.io/library/python:3.6.7"
-- Just "docker.io/library/python:3.6.8"
-- Just "docker.io/library/python:3.6.9"
-- Just "docker.io/library/python:3.7.0"
-- Just "docker.io/library/python:3.7.1"
-- Just "docker.io/library/python:3.7.10"
-- Just "docker.io/library/python:3.7.11"
-- Just "docker.io/library/python:3.7.12"
-- Just "docker.io/library/python:3.7.13"
-- Just "docker.io/library/python:3.7.14"
-- Just "docker.io/library/python:3.7.15"
-- Just "docker.io/library/python:3.7.16"
-- Just "docker.io/library/python:3.7.2"
-- Just "docker.io/library/python:3.7.3"
-- Just "docker.io/library/python:3.7.4"
-- Just "docker.io/library/python:3.7.5"
-- Just "docker.io/library/python:3.7.6"
-- Just "docker.io/library/python:3.7.7"
-- Just "docker.io/library/python:3.7.8"
-- Just "docker.io/library/python:3.7.9"
-- Just "docker.io/library/python:3.8.0"
-- Just "docker.io/library/python:3.8.1"
-- Just "docker.io/library/python:3.8.10"
-- Just "docker.io/library/python:3.8.11"
-- Just "docker.io/library/python:3.8.12"
-- Just "docker.io/library/python:3.8.13"
-- Just "docker.io/library/python:3.8.14"
-- Just "docker.io/library/python:3.8.15"
-- Just "docker.io/library/python:3.8.16"
-- Just "docker.io/library/python:3.8.2"
-- Just "docker.io/library/python:3.8.3"
-- Just "docker.io/library/python:3.8.4"
-- Just "docker.io/library/python:3.8.5"
-- Just "docker.io/library/python:3.8.6"
-- Just "docker.io/library/python:3.8.7"
-- Just "docker.io/library/python:3.8.8"
-- Just "docker.io/library/python:3.8.9"
-- Just "docker.io/library/python:3.9.0"
-- Just "docker.io/library/python:3.9.1"
-- Just "docker.io/library/python:3.9.10"
-- Just "docker.io/library/python:3.9.11"
-- Just "docker.io/library/python:3.9.12"
-- Just "docker.io/library/python:3.9.13"
-- Just "docker.io/library/python:3.9.14"
-- Just "docker.io/library/python:3.9.15"
-- Just "docker.io/library/python:3.9.16"
-- Just "docker.io/library/python:3.9.2"
-- Just "docker.io/library/python:3.9.3"
-- Just "docker.io/library/python:3.9.4"
-- Just "docker.io/library/python:3.9.5"
-- Just "docker.io/library/python:3.9.6"
-- Just "docker.io/library/python:3.9.7"
-- Just "docker.io/library/python:3.9.8"
-- Just "docker.io/library/python:3.9.9"

-- from https://en.wikipedia.org/wiki/History_of_Python
distributions : List Distribution
distributions =
  [ { interpreter = CPython, version = (0, 9,  0), latestMicroVersion = (0, 9,  9),  releaseDate = fromCalendarDate 1991 Feb 20, endOfSupport = fromCalendarDate 1993 Jul 29, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 0,  0), latestMicroVersion = (1, 0,  4),  releaseDate = fromCalendarDate 1994 Jan 26, endOfSupport = fromCalendarDate 1994 Feb 15, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 1,  0), latestMicroVersion = (1, 1,  1),  releaseDate = fromCalendarDate 1994 Oct 11, endOfSupport = fromCalendarDate 1994 Nov 10, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 2,  0), latestMicroVersion = (1, 2,  0),  releaseDate = fromCalendarDate 1995 Apr 13, endOfSupport = fromCalendarDate 1995 Apr 13, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 3,  0), latestMicroVersion = (1, 3,  0),  releaseDate = fromCalendarDate 1995 Oct 13, endOfSupport = fromCalendarDate 1995 Oct 13, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 4,  0), latestMicroVersion = (1, 4,  0),  releaseDate = fromCalendarDate 1996 Oct 25, endOfSupport = fromCalendarDate 1996 Oct 25, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 5,  0), latestMicroVersion = (1, 5,  2),  releaseDate = fromCalendarDate 1998 Jan  3, endOfSupport = fromCalendarDate 1999 Apr 13, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (1, 6,  0), latestMicroVersion = (1, 6,  1),  releaseDate = fromCalendarDate 2000 Sep  5, endOfSupport = fromCalendarDate 2000 Sep  1, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 0,  0), latestMicroVersion = (2, 0,  1),  releaseDate = fromCalendarDate 2000 Oct 16, endOfSupport = fromCalendarDate 2001 Jun 22, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 1,  0), latestMicroVersion = (2, 1,  3),  releaseDate = fromCalendarDate 2001 Apr 15, endOfSupport = fromCalendarDate 2002 Apr  9, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 2,  0), latestMicroVersion = (2, 2,  3),  releaseDate = fromCalendarDate 2001 Dec 21, endOfSupport = fromCalendarDate 2003 May 30, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 3,  0), latestMicroVersion = (2, 3,  7),  releaseDate = fromCalendarDate 2003 Jun 29, endOfSupport = fromCalendarDate 2008 Mar 11, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 4,  0), latestMicroVersion = (2, 4,  6),  releaseDate = fromCalendarDate 2004 Nov 30, endOfSupport = fromCalendarDate 2008 Dec 19, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 5,  0), latestMicroVersion = (2, 5,  6),  releaseDate = fromCalendarDate 2006 Sep 19, endOfSupport = fromCalendarDate 2011 May 26, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 6,  0), latestMicroVersion = (2, 6,  9),  releaseDate = fromCalendarDate 2008 Oct  1, endOfSupport = fromCalendarDate 2010 Aug 24, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (2, 7,  0), latestMicroVersion = (2, 7,  18), releaseDate = fromCalendarDate 2010 Jul  3, endOfSupport = fromCalendarDate 2020 Jan  1, dockerImage = Just "docker.io/library/python:2.7.18", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 0,  0), latestMicroVersion = (3, 0,  1),  releaseDate = fromCalendarDate 2008 Dec  3, endOfSupport = fromCalendarDate 2009 Jun 27, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 1,  0), latestMicroVersion = (3, 1,  5),  releaseDate = fromCalendarDate 2009 Jun 27, endOfSupport = fromCalendarDate 2011 Jun 12, dockerImage = Nothing, pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 2,  0), latestMicroVersion = (3, 2,  6),  releaseDate = fromCalendarDate 2011 Feb 20, endOfSupport = fromCalendarDate 2013 May 13, dockerImage = Just "docker.io/library/python:3.2.6", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 3,  0), latestMicroVersion = (3, 3,  7),  releaseDate = fromCalendarDate 2012 Sep 29, endOfSupport = fromCalendarDate 2014 Mar  8, dockerImage = Just "docker.io/library/python:3.3.7", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 4,  0), latestMicroVersion = (3, 4,  10), releaseDate = fromCalendarDate 2014 Mar 16, endOfSupport = fromCalendarDate 2017 Aug  9, dockerImage = Just "docker.io/library/python:3.4.10", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 5,  0), latestMicroVersion = (3, 5,  10), releaseDate = fromCalendarDate 2015 Sep 13, endOfSupport = fromCalendarDate 2017 Aug  8, dockerImage = Just "docker.io/library/python:3.5.10", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 6,  0), latestMicroVersion = (3, 6,  15), releaseDate = fromCalendarDate 2016 Dec 23, endOfSupport = fromCalendarDate 2018 Dec 24, dockerImage = Just "docker.io/library/python:3.6.15", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 7,  0), latestMicroVersion = (3, 7,  16), releaseDate = fromCalendarDate 2018 Jun 27, endOfSupport = fromCalendarDate 2020 Jun 27, dockerImage = Just "docker.io/library/python:3.7.16", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 8,  0), latestMicroVersion = (3, 8,  16), releaseDate = fromCalendarDate 2019 Oct 14, endOfSupport = fromCalendarDate 2021 May  3, dockerImage = Just "docker.io/library/python:3.8.16", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 9,  0), latestMicroVersion = (3, 9,  16), releaseDate = fromCalendarDate 2020 Oct  5, endOfSupport = fromCalendarDate 2022 May 17, dockerImage = Just "docker.io/library/python:3.9.16", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 10, 0), latestMicroVersion = (3, 10, 10), releaseDate = fromCalendarDate 2021 Oct  4, endOfSupport = fromCalendarDate 2023 May  1, dockerImage = Just "docker.io/library/python:3.10.10", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 11, 0), latestMicroVersion = (3, 11, 2),  releaseDate = fromCalendarDate 2022 Oct 24, endOfSupport = fromCalendarDate 2024 May  1, dockerImage = Just "docker.io/library/python:3.11.2", pyenvAvailable = False }
  , { interpreter = CPython, version = (3, 12, 0), latestMicroVersion = (3, 12, 0),  releaseDate = fromCalendarDate 2023 Oct  2, endOfSupport = fromCalendarDate 2025 May  1, dockerImage = Nothing, pyenvAvailable = False }
  ]

selectDistribution : String -> Maybe Distribution
selectDistribution version =
  List.foldr (\dist acc -> if versionToString dist.version == version then Just dist else acc) Nothing distributions

initialModel : Model
initialModel =
  { date = Err "No date selected"
  , distribution = Nothing
  , today = fromCalendarDate 2019 Jan 1
  }

main : Program () Model Msg
main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type Msg = SetWorkingDate String
         | SetTodayDate Date
         | SetDistribution String

init : () -> (Model, Cmd Msg)
init _ = (initialModel, Date.today |> Task.perform SetTodayDate)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetWorkingDate d ->
      ({ model | date = fromIsoString d }, Cmd.none)
    SetTodayDate d ->
      ({ model | today = d }, Cmd.none)
    SetDistribution version ->
      ({ model | distribution = selectDistribution version }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

toRetroPipUrl : Date -> String
toRetroPipUrl d = "https://retropip.com/" ++ (format "yyyy/MM/dd" d) ++ "/simple"

versionToString : PythonVersion -> String
versionToString version = 
  let
    (major, minor, patch) = version
  in
    "{{ major }}.{{ minor }}.{{ patch }}"
      |> String.Format.namedValue "major" (String.fromInt major)
      |> String.Format.namedValue "minor" (String.fromInt minor)
      |> String.Format.namedValue "patch" (String.fromInt patch)

dockerRecipe : Date -> String -> Html Msg
dockerRecipe date image =
  let
    template = """
FROM {{ image }}

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
                      |> String.Format.namedValue "image" image)
            ]


installRecipe : Date -> Html Msg
installRecipe date =
  let
    command = "$ pip install --index-url {{ indexUrl }} -r requirements.txt"
      |> String.Format.namedValue "indexUrl" (toRetroPipUrl date)
  in
    pre [] [ text command ]


viewRecipe : Model -> Html Msg
viewRecipe model =
  let
    { date, distribution } = model
  in
    case (date, distribution) of
      (Ok d, Just dist) ->
        case dist.dockerImage of
          Just image -> dockerRecipe d image
          Nothing -> installRecipe d
      _ -> pre [ ] [ text "# Please, select a date and a Python version" ]

introMessage : Html Msg
introMessage = 
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

distributionOption : Model -> Distribution -> Html Msg
distributionOption model dist =
  let
    hasDocker = ME.isJust dist.dockerImage
    released = not <| LT == (Date.compare (Result.withDefault model.today model.date) dist.releaseDate)
    endOfLife = not <| LT == (Date.compare (Result.withDefault model.today model.date) dist.endOfSupport)
    version = versionToString dist.version
    label = "{{ name }} {{ version }} {{ note }} {{ docker }}"
      |> String.Format.namedValue "name" (interpreterToString dist.interpreter)
      |> String.Format.namedValue "version" version
      |> String.Format.namedValue "note" (
        case (released, endOfLife) of
          (False, False) -> " - Not yet released"
          (True, True) -> " - End of life"
          _ -> ""
      )
      |> String.Format.namedValue "docker" (if hasDocker then "🐋" else "")
  in
    option [ Attr.value version ] [ text label ]

distributionSelector : Model -> Html Msg
distributionSelector model =
  div []
    [ label [ Attr.for "pythonDistribution" ] [ text "Python version:" ]
    , select [ onInput SetDistribution ] (List.map (distributionOption model) distributions)
    ]

view : Model -> Html Msg
view model =
  div []
    [ introMessage
    , workingDateSelector model
    , distributionSelector model
    , viewRecipe model
    ]
