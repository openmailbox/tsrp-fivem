SelectSession = {}

-- Forward delcarations
local setup_camera,
      setup_player

local LOCATION = vector3(-800.6982, 174.4930, 73.0790) -- Michael's house living room

local active_session = nil
local camera         = nil

function SelectSession.get_active()
    return active_session
end

function SelectSession:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function SelectSession:finish()
    active_session = nil

    SetCamActive(camera, false)
    RenderScriptCams(false, true, 1500, true, true)
    SetNuiFocus(false, false)

    if not self.hide_radar then
        DisplayRadar(true)
    end
end

function SelectSession:initialize()
    active_session = self

    local x, y, z = table.unpack(LOCATION)
    RequestCollisionAtCoord(x, y, z)
    RequestAdditionalCollisionAtCoord(x, y, z)

    -- Done this way b/c initialize() can be called multiple times during a session.
    if self.hide_radar ~= nil then
        self.hide_radar = IsRadarHidden()
    end

    DoScreenFadeOut(1500)
    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    setup_player()
    setup_camera()

    DisplayRadar(false)
    TriggerEvent(Events.CLEAR_CHAT)

    Citizen.Wait(1000)
    DoScreenFadeIn(1500)
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = Events.CREATE_CHARACTER_SELECT_SESSION
    })
end

-- @local
function setup_camera()
    local x, y, z = table.unpack(LOCATION)

    camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, 0, 0, 120.0, 70.0, false, 0)

    SetCamActive(camera, true)
    RenderScriptCams(true, true, 0, true, true)
end

-- @local
function setup_player()
    local ped     = PlayerPedId()
    local x, y, z = table.unpack(LOCATION)

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