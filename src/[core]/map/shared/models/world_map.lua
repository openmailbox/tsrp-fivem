-- Uses a 2d grid to spatially partition the map for storing things more efficiently.
WorldMap = {}

local CELL_SIZE       = 100
local NUM_CELLS       = 300
local WORLD_TRANSLATE = 15000

-- Forward declarations
local get_cell_xy,
      get_neighbors

local current

function WorldMap.find_objects(coords, label)
    local nearby = current:find_nearby_objects(coords, label)
    return nearby
end
exports("FindObjects", WorldMap.find_objects)

-- Start tracking a given object in the spatially partitioned map.
-- @treturn string the UUID of the newly tracked object.
function WorldMap.start_tracking(coords, label, object)
    local x, y, z = table.unpack(coords)

    local x1 = tonumber(string.format("%.2f", x))
    local y1 = tonumber(string.format("%.2f", y))
    local z1 = tonumber(string.format("%.2f", z))

    local uuid = current:add_object(vector3(x1, y1, z1), label, object)

    if PlayerMap then
        PlayerMap.current():update(true)
    end

    return uuid
end
exports("StartTracking", WorldMap.start_tracking)

-- Remove a previously tracked object.
-- @tparam vector3 coords
-- @tparam string label
-- @tparam string id the generated UUID from StartTracking
-- @treturn boolean success or failure
function WorldMap.stop_tracking(coords, label, id)
    local x, y, z = table.unpack(coords)

    local x1 = tonumber(string.format("%.2f", x))
    local y1 = tonumber(string.format("%.2f", y))
    local z1 = tonumber(string.format("%.2f", z))

    local success = current:remove_object(vector3(x1, y1, z1), label, id)

    if PlayerMap then
        PlayerMap.current():update(true)
    end

    return success
end
exports("StopTracking", WorldMap.stop_tracking)

function WorldMap.current()
    return current
end

function WorldMap.initialize()
    local cells = {}

    for x = 1, NUM_CELLS do
        cells[x] = {}

        for y = 1, NUM_CELLS do
            cells[x][y] = {}
        end
    end

    current = WorldMap:new({ cells = cells })

    return current
end

function WorldMap:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function WorldMap:add_object(coords, label, object)
    local cell, cx, cy = self:get_cell(coords)

    local storage = cell[label]
    local uuid    = GenerateUUID()

    if not storage then
        storage     = {}
        cell[label] = storage
    end

    object.world_id = uuid
    table.insert(storage, object)

    Logging.log(Logging.TRACE, "Added new '" .. label .. "' map object " ..uuid .. " at cell " .. cx .. ", " .. cy .. ".")

    return object.world_id
end

-- Returns all the known objects across the entire map for the given label
function WorldMap:find_all_objects(label)
    local results = {}

    for _, column in ipairs(self.cells) do
        for _, cell in ipairs(column) do
            for _, object in ipairs(cell[label] or {}) do
                table.insert(results, object)
            end
        end
    end

    return results
end

-- Returns stored objects for the given label in the current map cell and all surrounding
-- cells (in case something is on a border).
function WorldMap:find_nearby_objects(coords, label)
    local cell, cx, cy = self:get_cell(coords)

    local neighbors = get_neighbors(self, cx, cy)
    local nearby    = {}

    for _, object in ipairs(cell[label] or {}) do
        table.insert(nearby, object)
    end

    for _, neighbor in ipairs(neighbors) do
        for _, object in ipairs(neighbor[label] or {}) do
            table.insert(nearby, object)
        end
    end

    return nearby
end

function WorldMap:get_cell(coords)
    local cx, cy = get_cell_xy(coords)
    return self.cells[cx][cy], cx, cy
end

function WorldMap:remove_object(coords, label, world_id)
    local cell, cx, cy = self:get_cell(coords)

    local storage = cell[label]
    if not storage then return end

    for i, object in ipairs(storage) do
        if object.world_id == world_id then
            table.remove(storage, i)

            Logging.log(Logging.TRACE, "Removed '" .. label .. "' map object " .. world_id .. " at cell " .. cx .. ", " .. cy .. ".")

            return true
        end
    end

    return false
end

-- @local
function get_cell_xy(coords)
    -- use math.ceil() b/c Lua list in self.cells starts at index 1
    local cell_x = math.ceil((coords.x + WORLD_TRANSLATE) / CELL_SIZE)
    local cell_y = math.ceil((coords.y + WORLD_TRANSLATE) / CELL_SIZE)

    return cell_x, cell_y
end

-- @local
function get_neighbors(map, x, y)
    local neighbors = {}

    if y > 1 then
        table.insert(neighbors, map.cells[x][y - 1])

        if x < NUM_CELLS then table.insert(neighbors, map.cells[x + 1][y - 1]) end
        if x > 1 then table.insert(neighbors, map.cells[x - 1][y - 1]) end
    end

    if x > 1 then
        table.insert(neighbors, map.cells[x - 1][y])
        if y < NUM_CELLS then table.insert(neighbors, map.cells[x - 1][y + 1]) end
    end

    if y < NUM_CELLS then
        table.insert(neighbors, map.cells[x][y + 1])
        if x < NUM_CELLS then table.insert(neighbors, map.cells[x + 1][y + 1]) end
    end

    if x < NUM_CELLS then table.insert(neighbors, map.cells[x + 1][y]) end

    return neighbors
end
