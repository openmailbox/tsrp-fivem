PlayerVehicle = {}

local vehicles = {}

function PlayerVehicle.teardown()
    for _, rental in ipairs(vehicles) do
        rental:cleanup()
    end
end

function PlayerVehicle:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PlayerVehicle:cleanup()
    exports.keyring:RemoveKey(self.player_id, self.lock_id)

    if DoesEntityExist(self.entity) then
        DeleteEntity(self.entity)
    end
end

function PlayerVehicle:initialize()
    local hash       = GetHashKey(self.model)
    local x, y, z, h = table.unpack(self.spawn)
    local vehicle    = CreateVehicle(hash, x, y, z, h, true, false)
    local timeout    = GetGameTimer() + 3000

    repeat
        Citizen.Wait(10)
    until DoesEntityExist(vehicle) or GetGameTimer() > timeout

    SetVehicleDoorsLocked(vehicle, 2)

    if GetGameTimer() > timeout then
        Logging.log(Logging.WARN, "Timed out trying to spawn vehicle for " .. self.model .. ".")
        return
    end

    self.entity  = vehicle
    self.lock_id = exports.keyring:GiveKey(vehicle, self.player_id)

    table.insert(vehicles, self)

    TriggerClientEvent(Events.UPDATE_PLAYER_VEHICLES, self.player_id, {
        net_id  = NetworkGetNetworkIdFromEntity(vehicle),
        vehicle = self
    })
end
