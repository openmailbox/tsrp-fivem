-- Records moments in time from the player's current view of the map. Useful for understanding
-- population distributions at runtime for i.e. choosing mission locations.
Snapshot = {}

-- Forward declarations
local calc_centroid,
      calc_stdev,
      init_snapshot

local INTERVAL  = 60000       -- How often to record a snapshot for each 100x100 map cell
local MAP_LABEL = "snapshots" -- Label for WorldMap storage

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

-- Returns a list of vehicle models sorted by how many times the player has seen them during play.
function Snapshot.get_vehicle_distribution()
    local counts    = {}
    local results   = {}
    local snapshots = WorldMap.current():find_all_objects(MAP_LABEL)

    for _, snapshot in ipairs(snapshots) do
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

-- Returns a map location where a given vehicle model is most likely to spawn given the player's observations during play.
-- @treturn boolean if first return value is false, subsequent return values are not provided.
-- @treturn vector2 map location where the vehicle is most likely to spawn
function Snapshot.get_vehicle_spawn(model_hash)
    local snapshots = WorldMap.current():find_all_objects(MAP_LABEL)
    local target    = nil

    for _, snapshot in ipairs(snapshots) do
        local positions = snapshot.vehicles[model_hash] or {}

        if (not target and #positions > 0) or (#positions > 0 and #target.vehicles < #positions) then
            target = snapshot
        end
    end

    if not target then
        return false
    end

    local all_coords = target.vehicles[model_hash]
    local centroid   = calc_centroid(all_coords)
    local distances  = {}

    for _, coords in ipairs(all_coords) do
        table.insert(distances, Vdist(coords, centroid))
    end

    local stdev, mean = calc_stdev(distances)
    local norm_coords = {}

    -- Remove outliers > 2 standard deviations
    for i, distance in ipairs(distances) do
        local z = (distance - mean) / stdev

        if z > -2 and z < 2 then
            table.insert(norm_coords, all_coords[i])
        end
    end

    centroid = calc_centroid(norm_coords)

    return true, centroid, all_coords
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

    if recent then
        WorldMap.stop_tracking(coords, MAP_LABEL, recent.world_id)
    end

    WorldMap.start_tracking(coords, MAP_LABEL, snapshot)
end

-- @local
function calc_centroid(set)
    local x_sum = 0
    local y_sum = 0

    for _, coords in ipairs(set) do
        x_sum = x_sum + coords.x
        y_sum = y_sum + coords.y
    end

    return vector2(x_sum / #set, y_sum / #set)
end

-- @local
function calc_stdev(set)
    local sum = 0

    for _, member in ipairs(set) do
        sum = sum + member
    end

    local mean = sum / #set

    local sum_of_squares = 0

    for _, member in ipairs(set) do
        sum_of_squares = sum_of_squares + (member - mean) ^ 2
    end

    local variance = sum_of_squares / #set

    return math.sqrt(variance), mean
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
