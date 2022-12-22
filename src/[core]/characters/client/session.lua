---@diagnostic disable: duplicate-set-field
Session = {}

-- Forward delcarations
local setup_player,
      start_session

local LOCATION = vector3(-800.6982, 174.4930, 73.0790) -- Michael's house living room

local active_session = nil

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

    self.active = false
    self.camera:cleanup()

    SetNuiFocus(false, false)

    if not self.hide_radar then
        DisplayRadar(true)
    end
end

function Session:initialize()
    if active_session then return end
    active_session = self

    self.camera     = Camera:new({ location = LOCATION })
    self.hide_radar = IsRadarHidden()
    self.active     = true

    DoScreenFadeOut(1500)
    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    setup_player()
    self.camera:initialize()

    DisplayRadar(false)
    SetNuiFocus(true, true)
    TriggerEvent(Events.CLEAR_CHAT)

    SendNUIMessage({
        type  = Events.CREATE_CHARACTER_SELECT_SESSION
    })

    start_session(self)

    Citizen.Wait(1000)
    DoScreenFadeIn(1500)
end

-- @local
function start_session(sesh)
    Citizen.CreateThread(function()
        local session = sesh

        while session.active do
            session.camera:update()
            Citizen.Wait(0)
        end
    end)
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
