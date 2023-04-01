PlayerVehicle = {}

-- Forward declarations
local insert,
      spawn_entity,
      update

local vehicles = {}

function PlayerVehicle.active()
    return vehicles
end

function PlayerVehicle.for_entity(entity)
    if tonumber(entity) < 1 then return nil end

    for _, vehicle in ipairs(vehicles) do
        if vehicle.entity == entity then
            return vehicle
        end
    end

    return nil
end

function PlayerVehicle.teardown()
    for _, vehicle in ipairs(vehicles) do
        vehicle:cleanup()
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
    if not self.entity then
        self.entity = spawn_entity(self)
    end

    self.lock_id = exports.keyring:GiveKey(self.entity, self.player_id)

    if self.plate then
        SetVehicleNumberPlateText(self.entity, self.plate)
    else
        self.plate = GetVehicleNumberPlateText(self.entity)
    end

    table.insert(vehicles, self)

    TriggerClientEvent(Events.UPDATE_PLAYER_VEHICLES, self.player_id, {
        net_id  = NetworkGetNetworkIdFromEntity(self.entity),
        vehicle = self
    })
end

function PlayerVehicle:save()
    if self.renter then return end

    if self.id then
        update(self)
    else
        insert(self)
    end
end

function PlayerVehicle:tostring(_)
    local fields = {}

    for k, v in pairs(self) do
        if k == "snapshot" then
            table.insert(fields, k .. "=" .. json.encode(v))
        else
            table.insert(fields, k .. "=" .. tostring(v))
        end
    end

    return "PlayerVehicle{" .. table.concat(fields, ", ") .. "}"
end

-- @local
function insert(vehicle)
    local character = exports.characters:GetPlayerCharacter(vehicle.player_id)
    local snapshot  = VehicleSnapshot.for_vehicle(vehicle.entity)

    MySQL.Async.insert(
        "INSERT INTO vehicles (created_at, last_seen_at, character_id, model, plate, snapshot) VALUES (NOW(), NOW(), @char_id, @model, @plate, @snapshot);",
        {
            ["@char_id"]  = character.id,
            ["@model"]    = vehicle.model,
            ["@plate"]    = vehicle.plate,
            ["@snapshot"] = json.encode(snapshot)
        },
        function(new_id)
            vehicle.id       = new_id
            vehicle.snapshot = snapshot

            if not new_id then
                local name = character.first_name .. " " .. character.last_name

                Logging.log(Logging.WARN, "Failed to save new vehicle for " .. GetPlayerName(vehicle.player_id) .. " (" .. vehicle.player_id ..
                                          ") as " .. name .. ": " .. tostring(vehicle) .. ".")
            end
        end
    )
end

-- @local
function spawn_entity(vehicle)
    local hash       = GetHashKey(vehicle.model)
    local x, y, z, h = table.unpack(vehicle.spawn)
    local entity     = CreateVehicle(hash, x, y, z, h, true, false)
    local timeout    = GetGameTimer() + 3000

    repeat
        Citizen.Wait(10)
    until DoesEntityExist(entity) or GetGameTimer() > timeout

    SetVehicleDoorsLocked(entity, 2)

    if GetGameTimer() > timeout then
        Logging.log(Logging.WARN, "Timed out trying to spawn vehicle for " .. vehicle.model .. ".")
        return
    end

    return entity
end

-- @local
function update(vehicle)
    local snapshot = VehicleSnapshot.for_vehicle(vehicle.entity)

    MySQL.Async.execute(
        "UPDATE vehicles SET last_seen_at = NOW(), snapshot = @snapshot WHERE id = @id",
        {
            ["@snapshot"] = json.encode(snapshot),
            ["@id"]       = vehicle.id
        },
        function(rows_changed)
            if rows_changed == 0 then
                Logging.log(Logging.WARN, "Failed to update vehicle " .. vehicle.id .. " snapshot: " .. json.encode(snapshot) .. ".")
            end
        end
    )
end
