module Select exposing (..)

import Http
import String
import Task

import Html exposing (Html, text, input, div, ul, li)
import Html.App exposing (program)
import Html.Events exposing (onInput)
import Json.Decode as Json


main = program
       { init = ([], Cmd.none)
       , update = update
       , subscriptions = \model -> Sub.none
       , view = view
       }


type alias Model = List String


type Msg
    = Search String
    | Success (List String)
    | Fail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Search term ->
            let
                length = String.length term
            in
                if length == 0 then
                    ([], Cmd.none)
                else if length >= 3 then
                    (model, search term)
                else
                    (model, Cmd.none)
        Success results ->
            (results, Cmd.none)
        Fail _ ->
            (model, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput Search ] []
        , ul [] (List.map (\result -> li [] [ text result ]) model)
        ]


search : String -> Cmd Msg
search term =
    let
        url =
            "http://localhost:5000/search?term=" ++ term
    in
        Task.perform Fail Success (Http.get results url)


results =
    Json.at ["results"] (Json.list Json.string)
