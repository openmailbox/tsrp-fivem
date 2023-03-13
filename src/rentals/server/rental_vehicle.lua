RentalVehicle = {}

local rentals = {}

function RentalVehicle.teardown()
    for _, rental in ipairs(rentals) do
        rental:cleanup()
    end
end

function RentalVehicle:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function RentalVehicle:cleanup()
    if DoesEntityExist(self.entity) then
        DeleteEntity(self.entity)
    end
end

function RentalVehicle:initialize()
    local character  = exports.characters:GetPlayerCharacter(self.player_id)
    local hash       = GetHashKey(self.model)
    local x, y, z, h = table.unpack(self.spawn)
    local vehicle    = CreateVehicle(hash, x, y, z, h, true, false)
    local timeout    = GetGameTimer() + 3000

    repeat
        Citizen.Wait(10)
    until DoesEntityExist(vehicle) or GetGameTimer() > timeout

    if GetGameTimer() > timeout then
        Logging.log(Logging.WARN, "Timed out trying to create rental vehicle for " .. self.model .. ".")
        return
    end

    self.entity = vehicle
    table.insert(rentals, self)

    TriggerClientEvent(Events.UPDATE_RENTAL_VEHICLE, self.player_id, {
        net_id = NetworkGetNetworkIdFromEntity(vehicle)
    })

    Logging.log(Logging.INFO, GetPlayerName(self.player_id) .. " (" .. self.player_id .. ") as " .. character.first_name .. " " .. character.last_name ..
                              " rented a " .. self.model .. " for $" .. tostring(self.price or 0) .. " at the " .. self.renter .. ".")
end
