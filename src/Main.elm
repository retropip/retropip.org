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


-- -- from pyenv install -l
--  2.1.3
--  2.2.3
--  2.3.7
--  2.4.0
--  2.4.1
--  2.4.2
--  2.4.3
--  2.4.4
--  2.4.5
--  2.4.6
--  2.5.0
--  2.5.1
--  2.5.2
--  2.5.3
--  2.5.4
--  2.5.5
--  2.5.6
--  2.6.0
--  2.6.1
--  2.6.2
--  2.6.3
--  2.6.4
--  2.6.5
--  2.6.6
--  2.6.7
--  2.6.8
--  2.6.9
--  2.7.0
--  2.7-dev
--  2.7.1
--  2.7.2
--  2.7.3
--  2.7.4
--  2.7.5
--  2.7.6
--  2.7.7
--  2.7.8
--  2.7.9
--  2.7.10
--  2.7.11
--  2.7.12
--  2.7.13
--  2.7.14
--  2.7.15
--  2.7.16
--  2.7.17
--  2.7.18
--  3.0.1
--  3.1.0
--  3.1.1
--  3.1.2
--  3.1.3
--  3.1.4
--  3.1.5
--  3.2.0
--  3.2.1
--  3.2.2
--  3.2.3
--  3.2.4
--  3.2.5
--  3.2.6
--  3.3.0
--  3.3.1
--  3.3.2
--  3.3.3
--  3.3.4
--  3.3.5
--  3.3.6
--  3.3.7
--  3.4.0
--  3.4-dev
--  3.4.1
--  3.4.2
--  3.4.3
--  3.4.4
--  3.4.5
--  3.4.6
--  3.4.7
--  3.4.8
--  3.4.9
--  3.4.10
--  3.5.0
--  3.5-dev
--  3.5.1
--  3.5.2
--  3.5.3
--  3.5.4
--  3.5.5
--  3.5.6
--  3.5.7
--  3.5.8
--  3.5.9
--  3.5.10
--  3.6.0
--  3.6-dev
--  3.6.1
--  3.6.2
--  3.6.3
--  3.6.4
--  3.6.5
--  3.6.6
--  3.6.7
--  3.6.8
--  3.6.9
--  3.6.10
--  3.6.11
--  3.6.12
--  3.6.13
--  3.6.14
--  3.6.15
--  3.7.0
--  3.7-dev
--  3.7.1
--  3.7.2
--  3.7.3
--  3.7.4
--  3.7.5
--  3.7.6
--  3.7.7
--  3.7.8
--  3.7.9
--  3.7.10
--  3.7.11
--  3.7.12
--  3.7.13
--  3.7.14
--  3.7.15
--  3.7.16
--  3.8.0
--  3.8-dev
--  3.8.1
--  3.8.2
--  3.8.3
--  3.8.4
--  3.8.5
--  3.8.6
--  3.8.7
--  3.8.8
--  3.8.9
--  3.8.10
--  3.8.11
--  3.8.12
--  3.8.13
--  3.8.14
--  3.8.15
--  3.8.16
--  3.9.0
--  3.9-dev
--  3.9.1
--  3.9.2
--  3.9.4
--  3.9.5
--  3.9.6
--  3.9.7
--  3.9.8
--  3.9.9
--  3.9.10
--  3.9.11
--  3.9.12
--  3.9.13
--  3.9.14
--  3.9.15
--  3.9.16
--  3.10.0
--  3.10-dev
--  3.10.1
--  3.10.2
--  3.10.3
--  3.10.4
--  3.10.5
--  3.10.6
--  3.10.7
--  3.10.8
--  3.10.9
--  3.10.10
--  3.11.0
--  3.11-dev
--  3.11.1
--  3.11.2
--  3.12.0a5
--  3.12-dev
--  activepython-2.7.14
--  activepython-3.5.4
--  activepython-3.6.0
--  anaconda-1.4.0
--  anaconda-1.5.0
--  anaconda-1.5.1
--  anaconda-1.6.0
--  anaconda-1.6.1
--  anaconda-1.7.0
--  anaconda-1.8.0
--  anaconda-1.9.0
--  anaconda-1.9.1
--  anaconda-1.9.2
--  anaconda-2.0.0
--  anaconda-2.0.1
--  anaconda-2.1.0
--  anaconda-2.2.0
--  anaconda-2.3.0
--  anaconda-2.4.0
--  anaconda-4.0.0
--  anaconda2-2.4.0
--  anaconda2-2.4.1
--  anaconda2-2.5.0
--  anaconda2-4.0.0
--  anaconda2-4.1.0
--  anaconda2-4.1.1
--  anaconda2-4.2.0
--  anaconda2-4.3.0
--  anaconda2-4.3.1
--  anaconda2-4.4.0
--  anaconda2-5.0.0
--  anaconda2-5.0.1
--  anaconda2-5.1.0
--  anaconda2-5.2.0
--  anaconda2-5.3.0
--  anaconda2-5.3.1
--  anaconda2-2018.12
--  anaconda2-2019.03
--  anaconda2-2019.07
--  anaconda2-2019.10
--  anaconda3-2.0.0
--  anaconda3-2.0.1
--  anaconda3-2.1.0
--  anaconda3-2.2.0
--  anaconda3-2.3.0
--  anaconda3-2.4.0
--  anaconda3-2.4.1
--  anaconda3-2.5.0
--  anaconda3-4.0.0
--  anaconda3-4.1.0
--  anaconda3-4.1.1
--  anaconda3-4.2.0
--  anaconda3-4.3.0
--  anaconda3-4.3.1
--  anaconda3-4.4.0
--  anaconda3-5.0.0
--  anaconda3-5.0.1
--  anaconda3-5.1.0
--  anaconda3-5.2.0
--  anaconda3-5.3.0
--  anaconda3-5.3.1
--  anaconda3-2018.12
--  anaconda3-2019.03
--  anaconda3-2019.07
--  anaconda3-2019.10
--  anaconda3-2020.02
--  anaconda3-2020.07
--  anaconda3-2020.11
--  anaconda3-2021.04
--  anaconda3-2021.05
--  anaconda3-2021.11
--  anaconda3-2022.05
--  anaconda3-2022.10
--  cinder-3.8-dev
--  graalpy-22.3.0
--  graalpython-20.1.0
--  graalpython-20.2.0
--  graalpython-20.3.0
--  graalpython-21.0.0
--  graalpython-21.1.0
--  graalpython-21.2.0
--  graalpython-21.3.0
--  graalpython-22.0.0
--  graalpython-22.1.0
--  graalpython-22.2.0
--  ironpython-dev
--  ironpython-2.7.4
--  ironpython-2.7.5
--  ironpython-2.7.6.3
--  ironpython-2.7.7
--  jython-dev
--  jython-2.5.0
--  jython-2.5-dev
--  jython-2.5.1
--  jython-2.5.2
--  jython-2.5.3
--  jython-2.5.4-rc1
--  jython-2.7.0
--  jython-2.7.1
--  jython-2.7.2
--  mambaforge-pypy3
--  mambaforge
--  mambaforge-4.10.1-4
--  mambaforge-4.10.1-5
--  mambaforge-4.10.2-0
--  mambaforge-4.10.3-0
--  mambaforge-4.10.3-1
--  mambaforge-4.10.3-2
--  mambaforge-4.10.3-3
--  mambaforge-4.10.3-4
--  mambaforge-4.10.3-5
--  mambaforge-4.10.3-6
--  mambaforge-4.10.3-7
--  mambaforge-4.10.3-8
--  mambaforge-4.10.3-9
--  mambaforge-4.10.3-10
--  mambaforge-4.11.0-0
--  mambaforge-4.11.0-1
--  mambaforge-4.11.0-2
--  mambaforge-4.11.0-3
--  mambaforge-4.11.0-4
--  mambaforge-4.12.0-0
--  mambaforge-4.12.0-1
--  mambaforge-4.12.0-2
--  mambaforge-4.12.0-3
--  mambaforge-4.13.0-1
--  mambaforge-4.14.0-0
--  mambaforge-4.14.0-1
--  mambaforge-4.14.0-2
--  mambaforge-22.9.0-0
--  mambaforge-22.9.0-1
--  mambaforge-22.9.0-2
--  mambaforge-22.9.0-3
--  micropython-dev
--  micropython-1.9.3
--  micropython-1.9.4
--  micropython-1.10
--  micropython-1.11
--  micropython-1.12
--  micropython-1.13
--  micropython-1.14
--  micropython-1.15
--  micropython-1.16
--  micropython-1.17
--  micropython-1.18
--  micropython-1.19.1
--  miniconda-latest
--  miniconda-2.2.2
--  miniconda-3.0.0
--  miniconda-3.0.4
--  miniconda-3.0.5
--  miniconda-3.3.0
--  miniconda-3.4.2
--  miniconda-3.7.0
--  miniconda-3.8.3
--  miniconda-3.9.1
--  miniconda-3.10.1
--  miniconda-3.16.0
--  miniconda-3.18.3
--  miniconda2-latest
--  miniconda2-2.7-4.8.3
--  miniconda2-3.18.3
--  miniconda2-3.19.0
--  miniconda2-4.0.5
--  miniconda2-4.1.11
--  miniconda2-4.3.14
--  miniconda2-4.3.21
--  miniconda2-4.3.27
--  miniconda2-4.3.30
--  miniconda2-4.3.31
--  miniconda2-4.4.10
--  miniconda2-4.5.1
--  miniconda2-4.5.4
--  miniconda2-4.5.11
--  miniconda2-4.5.12
--  miniconda2-4.6.14
--  miniconda2-4.7.10
--  miniconda2-4.7.12
--  miniconda3-latest
--  miniconda3-2.2.2
--  miniconda3-3.0.0
--  miniconda3-3.0.4
--  miniconda3-3.0.5
--  miniconda3-3.3.0
--  miniconda3-3.4.2
--  miniconda3-3.7.0
--  miniconda3-3.7-4.8.2
--  miniconda3-3.7-4.8.3
--  miniconda3-3.7-4.9.2
--  miniconda3-3.7-4.10.1
--  miniconda3-3.7-4.10.3
--  miniconda3-3.7-4.11.0
--  miniconda3-3.7-4.12.0
--  miniconda3-3.7-22.11.1-1
--  miniconda3-3.8.3
--  miniconda3-3.8-4.8.2
--  miniconda3-3.8-4.8.3
--  miniconda3-3.8-4.9.2
--  miniconda3-3.8-4.10.1
--  miniconda3-3.8-4.10.3
--  miniconda3-3.8-4.11.0
--  miniconda3-3.8-4.12.0
--  miniconda3-3.8-22.11.1-1
--  miniconda3-3.9.1
--  miniconda3-3.9-4.9.2
--  miniconda3-3.9-4.10.1
--  miniconda3-3.9-4.10.3
--  miniconda3-3.9-4.11.0
--  miniconda3-3.9-4.12.0
--  miniconda3-3.9-22.11.1-1
--  miniconda3-3.10.1
--  miniconda3-3.10-22.11.1-1
--  miniconda3-3.16.0
--  miniconda3-3.18.3
--  miniconda3-3.19.0
--  miniconda3-4.0.5
--  miniconda3-4.1.11
--  miniconda3-4.2.12
--  miniconda3-4.3.11
--  miniconda3-4.3.14
--  miniconda3-4.3.21
--  miniconda3-4.3.27
--  miniconda3-4.3.30
--  miniconda3-4.3.31
--  miniconda3-4.4.10
--  miniconda3-4.5.1
--  miniconda3-4.5.4
--  miniconda3-4.5.11
--  miniconda3-4.5.12
--  miniconda3-4.6.14
--  miniconda3-4.7.10
--  miniconda3-4.7.12
--  miniforge-pypy3
--  miniforge3-latest
--  miniforge3-4.9.2
--  miniforge3-4.10
--  miniforge3-4.10.1-1
--  miniforge3-4.10.1-3
--  miniforge3-4.10.1-5
--  miniforge3-4.10.2-0
--  miniforge3-4.10.3-0
--  miniforge3-4.10.3-1
--  miniforge3-4.10.3-2
--  miniforge3-4.10.3-3
--  miniforge3-4.10.3-4
--  miniforge3-4.10.3-5
--  miniforge3-4.10.3-6
--  miniforge3-4.10.3-7
--  miniforge3-4.10.3-8
--  miniforge3-4.10.3-9
--  miniforge3-4.10.3-10
--  miniforge3-4.11.0-0
--  miniforge3-4.11.0-1
--  miniforge3-4.11.0-2
--  miniforge3-4.11.0-3
--  miniforge3-4.11.0-4
--  miniforge3-4.12.0-0
--  miniforge3-4.12.0-1
--  miniforge3-4.12.0-2
--  miniforge3-4.12.0-3
--  miniforge3-4.13.0-0
--  miniforge3-4.13.0-1
--  miniforge3-4.14.0-0
--  miniforge3-4.14.0-1
--  miniforge3-4.14.0-2
--  miniforge3-22.9.0-0
--  miniforge3-22.9.0-1
--  miniforge3-22.9.0-2
--  miniforge3-22.9.0-3
--  nogil-3.9.10
--  nogil-3.9.10-1
--  pypy-c-jit-latest
--  pypy-dev
--  pypy-stm-2.3
--  pypy-stm-2.5.1
--  pypy-1.5-src
--  pypy-1.6
--  pypy-1.7
--  pypy-1.8
--  pypy-1.9
--  pypy-2.0-src
--  pypy-2.0
--  pypy-2.0.1-src
--  pypy-2.0.1
--  pypy-2.0.2-src
--  pypy-2.0.2
--  pypy-2.1-src
--  pypy-2.1
--  pypy-2.2-src
--  pypy-2.2
--  pypy-2.2.1-src
--  pypy-2.2.1
--  pypy-2.3-src
--  pypy-2.3
--  pypy-2.3.1-src
--  pypy-2.3.1
--  pypy-2.4.0-src
--  pypy-2.4.0
--  pypy-2.5.0-src
--  pypy-2.5.0
--  pypy-2.5.1-src
--  pypy-2.5.1
--  pypy-2.6.0-src
--  pypy-2.6.0
--  pypy-2.6.1-src
--  pypy-2.6.1
--  pypy-4.0.0-src
--  pypy-4.0.0
--  pypy-4.0.1-src
--  pypy-4.0.1
--  pypy-5.0.0-src
--  pypy-5.0.0
--  pypy-5.0.1-src
--  pypy-5.0.1
--  pypy-5.1-src
--  pypy-5.1
--  pypy-5.1.1-src
--  pypy-5.1.1
--  pypy-5.3-src
--  pypy-5.3
--  pypy-5.3.1-src
--  pypy-5.3.1
--  pypy-5.4-src
--  pypy-5.4
--  pypy-5.4.1-src
--  pypy-5.4.1
--  pypy-5.6.0-src
--  pypy-5.6.0
--  pypy-5.7.0-src
--  pypy-5.7.0
--  pypy-5.7.1-src
--  pypy-5.7.1
--  pypy2-5.3-src
--  pypy2-5.3
--  pypy2-5.3.1-src
--  pypy2-5.3.1
--  pypy2-5.4-src
--  pypy2-5.4
--  pypy2-5.4.1-src
--  pypy2-5.4.1
--  pypy2-5.6.0-src
--  pypy2-5.6.0
--  pypy2-5.7.0-src
--  pypy2-5.7.0
--  pypy2-5.7.1-src
--  pypy2-5.7.1
--  pypy2.7-5.8.0-src
--  pypy2.7-5.8.0
--  pypy2.7-5.9.0-src
--  pypy2.7-5.9.0
--  pypy2.7-5.10.0-src
--  pypy2.7-5.10.0
--  pypy2.7-6.0.0-src
--  pypy2.7-6.0.0
--  pypy2.7-7.0.0-src
--  pypy2.7-7.0.0
--  pypy2.7-7.1.0-src
--  pypy2.7-7.1.0
--  pypy2.7-7.1.1-src
--  pypy2.7-7.1.1
--  pypy2.7-7.2.0-src
--  pypy2.7-7.2.0
--  pypy2.7-7.3.0-src
--  pypy2.7-7.3.0
--  pypy2.7-7.3.1-src
--  pypy2.7-7.3.1
--  pypy2.7-7.3.2-src
--  pypy2.7-7.3.2
--  pypy2.7-7.3.3-src
--  pypy2.7-7.3.3
--  pypy2.7-7.3.4-src
--  pypy2.7-7.3.4
--  pypy2.7-7.3.5-src
--  pypy2.7-7.3.5
--  pypy2.7-7.3.6-src
--  pypy2.7-7.3.6
--  pypy2.7-7.3.8-src
--  pypy2.7-7.3.8
--  pypy2.7-7.3.9-src
--  pypy2.7-7.3.9
--  pypy2.7-7.3.10-src
--  pypy2.7-7.3.10
--  pypy2.7-7.3.11-src
--  pypy2.7-7.3.11
--  pypy3-2.3.1-src
--  pypy3-2.3.1
--  pypy3-2.4.0-src
--  pypy3-2.4.0
--  pypy3.3-5.2-alpha1-src
--  pypy3.3-5.2-alpha1
--  pypy3.3-5.5-alpha-src
--  pypy3.3-5.5-alpha
--  pypy3.5-c-jit-latest
--  pypy3.5-5.7-beta-src
--  pypy3.5-5.7-beta
--  pypy3.5-5.7.1-beta-src
--  pypy3.5-5.7.1-beta
--  pypy3.5-5.8.0-src
--  pypy3.5-5.8.0
--  pypy3.5-5.9.0-src
--  pypy3.5-5.9.0
--  pypy3.5-5.10.0-src
--  pypy3.5-5.10.0
--  pypy3.5-5.10.1-src
--  pypy3.5-5.10.1
--  pypy3.5-6.0.0-src
--  pypy3.5-6.0.0
--  pypy3.5-7.0.0-src
--  pypy3.5-7.0.0
--  pypy3.6-7.0.0-src
--  pypy3.6-7.0.0
--  pypy3.6-7.1.0-src
--  pypy3.6-7.1.0
--  pypy3.6-7.1.1-src
--  pypy3.6-7.1.1
--  pypy3.6-7.2.0-src
--  pypy3.6-7.2.0
--  pypy3.6-7.3.0-src
--  pypy3.6-7.3.0
--  pypy3.6-7.3.1-src
--  pypy3.6-7.3.1
--  pypy3.6-7.3.2-src
--  pypy3.6-7.3.2
--  pypy3.6-7.3.3-src
--  pypy3.6-7.3.3
--  pypy3.7-c-jit-latest
--  pypy3.7-7.3.2-src
--  pypy3.7-7.3.2
--  pypy3.7-7.3.3-src
--  pypy3.7-7.3.3
--  pypy3.7-7.3.4-src
--  pypy3.7-7.3.4
--  pypy3.7-7.3.5-src
--  pypy3.7-7.3.5
--  pypy3.7-7.3.6-src
--  pypy3.7-7.3.6
--  pypy3.7-7.3.7-src
--  pypy3.7-7.3.7
--  pypy3.7-7.3.8-src
--  pypy3.7-7.3.8
--  pypy3.7-7.3.9-src
--  pypy3.7-7.3.9
--  pypy3.8-7.3.6-src
--  pypy3.8-7.3.6
--  pypy3.8-7.3.7-src
--  pypy3.8-7.3.7
--  pypy3.8-7.3.8-src
--  pypy3.8-7.3.8
--  pypy3.8-7.3.9-src
--  pypy3.8-7.3.9
--  pypy3.8-7.3.10-src
--  pypy3.8-7.3.10
--  pypy3.8-7.3.11-src
--  pypy3.8-7.3.11
--  pypy3.9-7.3.8-src
--  pypy3.9-7.3.8
--  pypy3.9-7.3.9-src
--  pypy3.9-7.3.9
--  pypy3.9-7.3.10-src
--  pypy3.9-7.3.10
--  pypy3.9-7.3.11-src
--  pypy3.9-7.3.11
--  pyston-2.2
--  pyston-2.3
--  pyston-2.3.1
--  pyston-2.3.2
--  pyston-2.3.3
--  pyston-2.3.4
--  pyston-2.3.5
--  stackless-dev
--  stackless-2.7-dev
--  stackless-2.7.2
--  stackless-2.7.3
--  stackless-2.7.4
--  stackless-2.7.5
--  stackless-2.7.6
--  stackless-2.7.7
--  stackless-2.7.8
--  stackless-2.7.9
--  stackless-2.7.10
--  stackless-2.7.11
--  stackless-2.7.12
--  stackless-2.7.14
--  stackless-2.7.16
--  stackless-3.2.2
--  stackless-3.2.5
--  stackless-3.3.5
--  stackless-3.3.7
--  stackless-3.4-dev
--  stackless-3.4.2
--  stackless-3.4.7
--  stackless-3.5.4
--  stackless-3.7.5

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
toRetroPipUrl d = "https://retropip.org/" ++ (format "yyyy/MM/dd" d) ++ "/simple"

seriesToString : PythonVersion -> String
seriesToString version =
  let
    (major, minor, _) = version
  in
    "{{ major }}.{{ minor }}.x"
      |> String.Format.namedValue "major" (String.fromInt major)
      |> String.Format.namedValue "minor" (String.fromInt minor)

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
    [ h1 [ ] [ text "Welcome to retropip.org!" ]
    , p [] [ text "Your old Python projects don't have to die!" ]
    , p [] [ text "At retropip, we know how frustrating it can be when outdated dependencies and tools prevent your code from running. That's why we've created a platform that makes it easy for Python developers to revive old programs and keep them running smoothly." ]
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
    series = seriesToString dist.version
    version = versionToString dist.version
    label = "{{ name }} {{ series }} {{ note }} {{ docker }}"
      |> String.Format.namedValue "name" (interpreterToString dist.interpreter)
      |> String.Format.namedValue "series" series
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
