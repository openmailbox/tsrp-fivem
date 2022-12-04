-- Records moments in time from the player's current view of the map. Useful for understanding
-- population distributions at runtime for i.e. choosing mission locations.
Snapshot = {}

-- Forward declarations
local init_snapshot

local INTERVAL    = 60000       -- How often to record a snapshot for each 100x100 map cell
local MAP_LABEL   = "snapshots" -- Label for WorldMap storage
local MAX_HISTORY = 5           -- Max size of recent snapshots list

local history = {} -- List of most recent snapshots

-- Returns the most recent snapshot for the given location or nil
function Snapshot.for_coords(coords)
    local snapshots = WorldMap.find_objects(coords, MAP_LABEL)

    if #snapshots == 0 then
        return nil
    end

    table.sort(snapshots, function(a, b)
        return a.created_at > b.created_at
    end)

    return snapshots[1]
end

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
    local coords = GetEntityCoords(PlayerPedId())
    local recent = Snapshot.for_coords(coords)
    local time   = GetGameTimer()

    if recent and time < recent.created_at + INTERVAL then
        return
    end

    local snapshot = init_snapshot(time)

    WorldMap.start_tracking(coords, MAP_LABEL, snapshot)

    if recent then
        WorldMap.stop_tracking(coords, MAP_LABEL, recent.world_id)

        -- No more than one entry in the historical list for a single map cell
        for i, s in ipairs(history) do
            if s == recent then
                table.remove(history, i)
                break
            end
        end
    end

    table.insert(history, snapshot)

    if #history > MAX_HISTORY then
        table.remove(history) -- removes first element
    end
end

-- @local
function init_snapshot(time)
    local pool     = GetGamePool("CVehicle")
    local snapshot = { vehicles = {}, created_at = time }
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

    return snapshot
end
