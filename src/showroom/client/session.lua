Session = {}

-- Forward delcarations
local setup_camera,
      setup_player,
      teardown_player

local CAM_POSITION = vector4(-45.6331, -1102.1134, 26.4224, 326.5543)
local VEH_POSITION = vector3(-43.8665, -1098.5597, 26.4224)

local active_session = nil
local awaiting       = 0
local camera         = nil

function Session.await()
    awaiting = awaiting + 1
end

function Session.get_active()
    return active_session
end

function Session:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Session:finish()
    active_session = nil

    local x, y, z = table.unpack(VEH_POSITION)
    RequestCollisionAtCoord(x, y, z)
    RequestAdditionalCollisionAtCoord(x, y, z)

    DoScreenFadeOut(1500)
    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    SetCamActive(camera, false)
    RenderScriptCams(false, false, 1500, true, true)
    SetNuiFocus(false, false)
    DisplayRadar(true)
    TriggerServerEvent(Events.DELETE_SHOWROOM_SESSION)

    teardown_player(self.origin)

    local timeout = GetGameTimer() + 5000
    repeat
        Citizen.Wait(100)
    until HasCollisionLoadedAroundEntity(PlayerPedId()) or GetGameTimer() > timeout

    DoScreenFadeIn(1500)
end

function Session:initialize()
    active_session = self

    self.origin = GetEntityCoords(PlayerPedId())

    local x, y, z = table.unpack(VEH_POSITION)
    RequestCollisionAtCoord(x, y, z)
    RequestAdditionalCollisionAtCoord(x, y, z)

    DoScreenFadeOut(1500)
    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    TriggerServerEvent(Events.CREATE_SHOWROOM_SESSION) -- will instance the player
    ShutdownLoadingScreen()

    setup_player()
    setup_camera()

    DisplayRadar(false)
    TriggerEvent(Events.CLEAR_CHAT)

    local timeout = GetGameTimer() + 5000
    repeat
        Citizen.Wait(100)
    until HasCollisionLoadedAroundEntity(PlayerPedId()) or GetGameTimer() > timeout

    DoScreenFadeIn(1500)
    SetNuiFocus(true, true)

    SendNUIMessage({ type = Events.CREATE_SHOWROOM_SESSION, categories = self.categories })
end

-- @local
function setup_camera()
    local x, y, z = table.unpack(CAM_POSITION)

    camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, 0, 0, 0, 70.0, false, 0)

    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, true)
end

-- @local
function setup_player()
    local ped     = PlayerPedId()
    local x, y, z = table.unpack(VEH_POSITION)

    ClearPedTasksImmediately(ped)
    SetEntityVisible(ped, false)
    NetworkResurrectLocalPlayer(x, y, z, 0, true, false)
    SetEntityCollision(ped, false)
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityCoordsNoOffset(ped, x, y, z)
end

-- @local
function teardown_player(origin)
    local ped     = PlayerPedId()
    local x, y, z = table.unpack(origin)

    SetEntityCoordsNoOffset(ped, x, y, z)
    SetEntityVisible(ped, true)
    SetEntityCollision(ped, true)
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(PlayerId(), false)
end
