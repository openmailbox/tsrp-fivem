---@diagnostic disable: duplicate-set-field
Session = {}

-- Forward delcarations
local start_session

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

    self.camera     = Camera:new()
    self.hide_radar = IsRadarHidden()
    self.active     = true

    self.camera:initialize()

    DisplayRadar(false)
    SetNuiFocus(true, true)
    TriggerEvent(Events.CLEAR_CHAT)

    SendNUIMessage({
        type  = Events.CREATE_CHARACTER_SELECT_SESSION
    })

    start_session(self)
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
