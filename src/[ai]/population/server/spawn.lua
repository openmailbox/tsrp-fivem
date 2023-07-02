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
        Logging.log(Logging.DEBUG, "Removing entity for " .. self.model .. " at " .. self.location .. ".")
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

    SetPedConfigFlag(self.entity, 17, true)

    if self.init_state then
        local sbag = Entity(self.entity).state

        for k, v in pairs(self.init_state) do
            sbag[k] = v
        end
    end

    if DoesEntityExist(self.entity) then
        Logging.log(Logging.TRACE, "Spawned " .. self.model .. " at " .. self.location .. ".")
        TriggerEvent(Events.ON_ENTITY_CREATED, self.entity) -- doesn't happen normally for server-spawned peds it seems
    else
        Logging.log(Logging.WARN, "Unable to spawn " .. self.model .. " at " .. self.location .. ".")
    end
end
