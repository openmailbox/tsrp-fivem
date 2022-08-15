local DICTIONARY = "clothingshirt"
local ANIMATION  = "try_shirt_positive_a"

local camera     = nil
local hide_radar = nil

local function create()
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = Events.CREATE_WARDROBE_SESSION
    })

    local cloc = GetGameplayCamCoord()
    local ploc = GetEntityCoords(PlayerPedId())
    local spot = ploc - (norm(ploc - cloc) * 2)

    camera     = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", spot.x, spot.y, ploc.z + 0.2, 0, 0, 0, 65.0, false, 0)
    hide_radar = IsRadarHidden()

    -- TODO: Adjust DoF
    PointCamAtEntity(camera, PlayerPedId(), -0.9, 0, 0, 1)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1500, true, true)
    DisplayRadar(false)
    TriggerEvent(Events.CLEAR_CHAT)

    -- TODO: Poll for health/armor changes and position changes, and kill session if detected.

    TaskTurnPedToFaceCoord(PlayerPedId(), spot.x, spot.y, ploc.z, -1)

    if not HasAnimDictLoaded(DICTIONARY) then
        RequestAnimDict(DICTIONARY)
    end

    while not HasAnimDictLoaded(DICTIONARY) do
        Citizen.Wait(10)
    end

    TaskPlayAnim(PlayerPedId(), DICTIONARY, ANIMATION, -3.0, 3.0, -1, 48, false, false, false)
end
AddEventHandler(Events.CREATE_WARDROBE_SESSION, create)

local function delete(_, cb)
    SetCamActive(camera, false)
    RenderScriptCams(false, true, 1500, true, true)

    local away = GetEntityCoords(PlayerPedId()) + (-2 * GetEntityForwardVector(PlayerPedId()))
    TaskTurnPedToFaceCoord(PlayerPedId(), away.x, away.y, away.z, 1000)

    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())

    if not hide_radar then
        DisplayRadar(true)
    end

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
