PhoneSession = {}

local current_session = nil

function PhoneSession.get_current()
    return current_session
end

function PhoneSession:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PhoneSession:cleanup()
    current_session = nil
    SetNuiFocus(false, false)
end

function PhoneSession:initialize()
    current_session = self
    SendNUIMessage({ type = Events.CREATE_PHONE_SESSION })
    SetNuiFocus(true, true)
end
