import Array exposing (Array)
import Html exposing (Html, div, ul, li, text, button)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick)


main = beginnerProgram
       { model = model
       , update = update
       , view = view
       }


-- MODEL

type alias Data =
    { value : Int
    , text : String
    }


type alias Model = Array Data


toData : Int -> Data
toData int =
    Data int (toString int)


model : Model
model = Array.empty


-- UPDATE

type Msg
    = Increase
    | Decrease
    | BulkIncrease Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            addItem model
        Decrease ->
            removeItem model
        BulkIncrease n ->
            addItems n model


addItem : Model -> Model
addItem model =
    Array.push (toData (Array.length model)) model


addItems : Int -> Model -> Model
addItems n model =
    if n == 0 then
        model
    else
        addItems (n - 1) (addItem model)


removeItem : Model -> Model
removeItem model =
    Array.slice 0 -1 model


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Increase) ] [ text "Increase" ]
        , button [ onClick Decrease ] [ text "Decrease" ]
        , ul [] (Array.toList (Array.map viewData model))
        ]


viewData: Data -> Html Msg
viewData data =
    li [ value (toString data.value), onClick (BulkIncrease data.value) ] [ text data.text ]
