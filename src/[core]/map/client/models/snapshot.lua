Snapshot = {}

local MAX_HISTORY = 3

local history = {}

-- Returns a list of vehicle models ordered by how often the player has encountered them recently.
function Snapshot.get_vehicle_distribution()
    local counts  = {}
    local results = {}

    for _, snapshot in ipairs(history) do
        for hash, positions in pairs(snapshot.vehicles) do
            counts[hash] = (counts[hash] or 0) + #positions
        end
    end

    for hash, amount in pairs(counts) do
        table.insert(results, {
            model = hash,
            count = amount
        })
    end

    table.sort(results, function(a, b)
        return a.count > b.count
    end)

    return results
end
exports("GetVehicleDistribution", Snapshot.get_vehicle_distribution)

-- Returns an area where a given vehicle model is most likely to spawn given the player's observations during
-- the current play session.
-- @treturn boolean if first return value is false, subsequent return values are not provided.
-- @treturn vector2 map location where the vehicle is most likely to spawn
function Snapshot.get_vehicle_spawn(model_hash)
    local count = 0
    local x_sum = 0
    local y_sum = 0

    for _, snapshot in ipairs(history) do
        local positions = snapshot.vehicles[model_hash] or {}

        count = count + #positions

        for _, coords in ipairs(positions) do
            x_sum = x_sum + coords.x
            y_sum = y_sum + coords.y
        end
    end

    if count == 0 then
        return false
    end

    local origin = vector2(x_sum / count, y_sum / count)

    return true, origin
end
exports("GetVehicleSpawn", Snapshot.get_vehicle_spawn)

function Snapshot.record()
    local pool     = GetGamePool("CVehicle")
    local snapshot = { vehicles = {} }
    local ped      = PlayerPedId()
    local mine     = GetVehiclePedIsIn(ped)

    local model, list

    for _, entity in ipairs(pool) do
        if entity ~= mine then
            model = GetEntityModel(entity)
            list  = snapshot.vehicles[model]

            if not list then
                list = {}
                snapshot.vehicles[model] = list
            end

            table.insert(list, GetEntityCoords(entity))
        end
    end

    table.insert(history, snapshot)

    if #history > MAX_HISTORY then
        table.remove(history) -- removes first element
    end
end
