Session = {}

-- Forward delcarations
local show_instructions,
      setup_player,
      teardown_player

local VEH_POSITION = vector4(-964.0110, -2984.2451, 13.9451, 52.9634)

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

function Session:finish(data)
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

    if self.callback then
        self.callback(data)
    end
end

function Session:initialize()
    if active_session then return end
    active_session = self

    self.origin           = GetEntityCoords(PlayerPedId())
    self.vehicle_location = VEH_POSITION

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
    show_instructions()

    DisplayRadar(false)
    TriggerEvent(Events.CLEAR_CHAT)

    local timeout = GetGameTimer() + 5000
    repeat
        Citizen.Wait(100)
    until HasCollisionLoadedAroundEntity(PlayerPedId()) or GetGameTimer() > timeout

    DoScreenFadeIn(1500)
    SetNuiFocus(true, true)

    SendNUIMessage({
        type       = Events.CREATE_SHOWROOM_SESSION,
        categories = self.categories,
        action     = self.action
    })
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

-- @local
function show_instructions()
    Citizen.CreateThread(function()
        local scaleform = CreateInstructionalDisplay("Turn Left", 34, "Turn Right", 35, "Exit", 200)

        while active_session do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Citizen.Wait(0)
        end
    end)
end
