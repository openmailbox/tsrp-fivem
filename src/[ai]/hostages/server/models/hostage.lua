Hostage = {}

function Hostage:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Hostage:cleanup()
    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = "Hostage " .. self.net_id .. " was removed."
    })
end

function Hostage:initialize()
    self.initialized_at = GetGameTimer()

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(self.enactor) .. " (" .. self.enactor .. ") took a new hostage (" .. self.net_id .. ")."
    })

    self:move_to(HostageStates.WAITING)
end

function Hostage:move_to(new_state)
    if self.state == new_state then return end

    TriggerEvent(Events.LOG_MESSAGE, {
        level = Logging.DEBUG,
        message = "Hostage " .. self.net_id .. " moving to state " .. new_state .. "."
    })

    self.state          = new_state
    self.last_change_at = GetGameTimer()

    if DoesEntityExist(self.entity) then
        Entity(self.entity).state.hostage_state = new_state
    end
end
