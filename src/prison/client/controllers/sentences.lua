-- Forward declarations
local init_scaleform

local timeout = 0

local function create(_)
    if timeout > GetGameTimer() then return end
    timeout = GetGameTimer() + 3000

    local scaleform = init_scaleform()

    Citizen.CreateThread(function()
        while GetGameTimer() < timeout do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Citizen.Wait(0)
        end
    end)

    Citizen.Wait(2000)
    TriggerServerEvent(Events.CREATE_PRISON_SENTENCE)
end
RegisterNetEvent(Events.CREATE_PRISON_SENTENCE, create)

-- @local
function init_scaleform()
    local scaleform = RequestScaleformMovie("mp_big_message_freemode")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 1)
    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieMethodParameterString("BUSTED")
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterInt(5)
    EndScaleformMovieMethod()

    return scaleform
end
