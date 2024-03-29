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

-- Returns a list of local ped types sorted by how often the player has seen them during play.
function Snapshot.get_ped_distribution()
    local snapshots = WorldMap.current():find_all_objects(MAP_LABEL)
    local totals    = {}
    local results   = {}

    for _, s in ipairs(snapshots) do
        for ptype, count in pairs(s.locals) do
            totals[ptype] = (totals[ptype] or 0) + count
        end
    end

    for ptype, count in pairs(totals) do
        table.insert(results, {
            type  = ptype,
            count = count
        })
    end

    table.sort(results, function(a, b)
        return a.count < b.count
    end)

    return results
end
exports("GetPedDistribution", Snapshot.get_ped_distribution)

-- Returns a chronologically ordered list of player's most recent locations.
function Snapshot.get_player_history()
    local snapshots = WorldMap.current():find_all_objects(MAP_LABEL)
    local sorted    = {}
    local results   = {}
    local lookback  = GetGameTimer() - (1000 * 60 * 30)

    for _, s in ipairs(snapshots) do
        if s.created_at > lookback then
            table.insert(sorted, s)
        end
    end

    table.sort(sorted, function(a, b)
        return a.created_at < b.created_at
    end)

    for _, s in ipairs(sorted) do
        table.insert(results, {
            location   = s.location,
            created_at = s.created_at
        })
    end

    return results
end
exports("GetPlayerHistory", Snapshot.get_player_history)

-- Returns a list of vehicle models sorted by how many times the player has seen them during play.
function Snapshot.get_vehicle_distribution()
    local filtered  = {}
    local results   = {}
    local snapshots = WorldMap.current():find_all_objects(MAP_LABEL)

    for _, snapshot in ipairs(snapshots) do
        for hash, positions in pairs(snapshot.vehicles) do
            filtered[hash] = filtered[hash] or {}

            local set = filtered[hash]

            -- Make sure we're not counting the same vehicle twice across multiple snapshots
            for _, p in ipairs(positions) do
                if not set[p] then
                    set[p] = true
                end
            end
        end
    end

    for hash, positions in pairs(filtered) do
        local count = 0

        for _, _ in pairs(positions) do
            count = count + 1
        end

        table.insert(results, {
            model = hash,
            count = count
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
        local unique = {}
        local count  = 0

        for _, p in ipairs(snapshot.vehicles[model_hash] or {}) do
            if not unique[p] then
                unique[p] = true
                count = count + 1
            end
        end

        if (not target and count > 0) or (count > 0 and #target.vehicles < count) then
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
    local vehicles = GetGamePool("CVehicle")
    local peds     = GetGamePool("CPed")
    local ped      = PlayerPedId()
    local mine     = GetVehiclePedIsIn(ped)
    local snapshot = {
        created_at = time,
        locals     = {},
        location   = GetEntityCoords(ped),
        vehicles   = {},
    }

    -- Loop variables
    local model, list, ptype

    for _, entity in ipairs(vehicles) do
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

    for _, entity in ipairs(peds) do
        ptype = GetPedType(entity)
        snapshot.locals[ptype] = (snapshot.locals[ptype] or 0) + 1
    end

    return snapshot
end
