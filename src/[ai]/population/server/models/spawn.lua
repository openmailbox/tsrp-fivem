Spawn = {}

function Spawn:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Spawn:cleanup()
    if self.entity then
        DeleteEntity(self.entity)

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Removing entity for " .. self.model .. " at " .. self.location .. "."
        })
    end
end

function Spawn:initialize()
    self.id = GenerateUUID() -- defined in @common/shared/uuid

    local x, y, z = table.unpack(self.location)
    local timeout = GetGameTimer() + 3000

    self.entity = CreatePed(4, GetHashKey(self.model), x, y, z, self.heading, true, false)

    repeat
       Citizen.Wait(10)
    until DoesEntityExist(self.entity) or GetGameTimer() > timeout

    if DoesEntityExist(self.entity) then
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.INFO,
            message = "Spawned " .. self.model .. " at " .. self.location .. "."
        })
    else
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.WARN,
            message = "Unable to spawn " .. self.model .. " at " .. self.location .. "."
        })
    end
end
