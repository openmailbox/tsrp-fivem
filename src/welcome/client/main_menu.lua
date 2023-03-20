MainMenu = {}

-- Forward declarations
local disable_controls,
      setup_camera,
      setup_player

local LOCATIONS = {
    { -- Legion Square
        origin      = vector3(263.642, -832.021, 71.2323),
        destination = vector3(183.316, -823.365, 31.167)
    },
    { -- Pier
        origin      = vector3(-1823.697, -1188.846, 26.535),
        destination = vector3(-1700.678, -1100.722,27.965)
    },
    { -- Bridge
        origin      = vector3(-245.635, -2522.51, 87.974),
        destination = vector3(-353.711,-2357.904, 71.939)
    }
}

local menu_active = false

function MainMenu.start()
    menu_active = true

    local location = LOCATIONS[math.random(1, #LOCATIONS)]

    DoScreenFadeOut(2000)

    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    TriggerEvent(Events.CLEAR_CHAT)
    DisplayRadar(false)

    disable_controls()
    setup_player(location.origin)
    setup_camera(location.origin, location.destination)

    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    Citizen.Wait(2000)

    SendNUIMessage({
        type = Events.CREATE_WELCOME_SESSION
    })

    Citizen.Wait(2000)
    SetNuiFocus(true, true)
    DoScreenFadeIn(2000)
end

function MainMenu.stop()
    menu_active = false
    SetNuiFocus(false, false)
end

-- @local
function disable_controls()
    Citizen.CreateThread(function()
        while menu_active do
            DisableControlAction(0, 249, true) -- push to talk
            Citizen.Wait(0)
        end
    end)
end

-- @local
function setup_camera(origin, target)
    local x, y, z    = table.unpack(origin)
    local dx, dy, dz = table.unpack(target)

    local camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, 0, 0, 120.0, 70.0, false, 0)

    PointCamAtCoord(camera, dx, dy, dz)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 0, true, true)
end

-- @local
function setup_player(origin)
    local x, y, z = table.unpack(origin)
    local ped     = PlayerPedId()

    ClearPedTasksImmediately(ped)
    SetEntityVisible(ped, false)
    RemoveAllPedWeapons(ped)
    ClearPlayerWantedLevel(ped)
    NetworkResurrectLocalPlayer(x, y, z, 0, true, false)
    SetEntityCollision(ped, false)
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityCoordsNoOffset(ped, x, y, z)
end
