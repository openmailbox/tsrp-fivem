Hostage = {}

function Hostage:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Hostage:cleanup()
    local owner = nil

    if DoesEntityExist(self.entity) then
        owner = NetworkGetEntityOwner(self.entity)
    else
        owner = self.last_owner
    end

    TriggerClientEvent(Events.DELETE_NEW_HOSTAGE, owner, self)
end

function Hostage:initialize()
    self.last_owner = NetworkGetEntityOwner(self.entity)
    TriggerClientEvent(Events.CREATE_NEW_HOSTAGE, self.last_owner, self)

    ClearPedTasks(self.entity)
    TaskHandsUp(self.entity, -1, self.enactor, -1, 1)

    self.initialized_at = os.time()

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Initialized " .. self.entity .. " as a hostage."
    })
end

-- Make a decision about what to do next
function Hostage:update()
    self.last_owner = NetworkGetEntityOwner(self.entity)
end
