module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import File exposing (File)
import File.Select as Select
import Html exposing (Html, button, div, h1, img, span, text)
import Html.Attributes exposing (src)
import Html.Events exposing (..)
import Json.Decode as D
import Task



---- MODEL ----


type alias Model =
    { file : Maybe File
    , fileContent : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing Nothing, Cmd.none )



---- UPDATE ----


type Msg
    = AskUserToSelect
    | GotFile File
    | FileLoaded String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFile file ->
            ( { model | file = Just file }, Task.perform FileLoaded (File.toString file) )

        AskUserToSelect ->
            ( model, selectFile )

        FileLoaded fileContent ->
            ( { model | fileContent = Just fileContent }, Cmd.none )



---- VIEW ----


selectFile =
    Select.file [ "image/png" ] GotFile


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick AskUserToSelect ] [ text "Select a file" ]
        , span []
            [ text <|
                Maybe.withDefault "No file selected yet" model.fileContent
            ]
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
