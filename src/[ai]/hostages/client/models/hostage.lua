Hostage = {}

local States = {
    READY    = 1,
    RELEASED = 2
}

function Hostage:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Hostage:initialize()
    ClearPedTasks(self.ped)
    SetBlockingOfNonTemporaryEvents(self.ped, true)
    TaskSetBlockingOfNonTemporaryEvents(self.ped, true)
    TaskHandsUp(self.ped, -1, self.enactor, -1, 1)

    self.initialized_at = GetGameTimer()
    self.state          = States.READY

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Initialized " .. self.ped .. " as a hostage."
    })
end

function Hostage:release()
    self.state = States.RELEASED

    SetBlockingOfNonTemporaryEvents(self.ped, false)
    TaskSetBlockingOfNonTemporaryEvents(self.ped, false)

    local x, y, z = table.unpack(GetEntityCoords(self.ped))
    TaskSmartFleeCoord(self.ped, x, y, z, 500.0, -1, 0, 0)

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Release hostage " .. self.ped .. "."
    })
end

-- Make a decision about what to do next
function Hostage:update()
    if self.state == States.READY and GetGameTimer() > self.initialized_at + 5000 then
        self:release()
    end
end
