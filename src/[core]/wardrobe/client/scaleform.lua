-- TODO: Need a better home for this.
function CreateInstructionalDisplay(...)
    local parameters = table.pack(...)
    local scaleform  = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    local count = 0
    for i = parameters.n, 1, -2 do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(count)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, parameters[i], true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(parameters[i-1])
        EndTextCommandScaleformString()
        PopScaleformMovieFunctionVoid()
        count = count + 1
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
