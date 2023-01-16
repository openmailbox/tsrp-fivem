Heist = {}

-- Forward declarations
local any_players_nearby,
      dist2d

local heists = {}

function Heist.all()
    return heists
end

function Heist.cleanup()
    for _, heist in ipairs(heists) do
        for _, spawn in ipairs(heist.spawns) do
            exports.population:RemoveSpawn(spawn.id)
        end
    end

    heists = {}
end

function Heist.find_closest(coords)
    local closest_heist = nil
    local closest_dist  = 100000
    local distance      = nil

    for _, heist in ipairs(heists) do
        distance = dist2d(coords, heist.location)

        if distance < closest_dist and distance < heist.radius then
            closest_dist  = distance
            closest_heist = heist
        end
    end

    return closest_heist
end

-- @tparam HeistLocation o
function Heist:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Called when a player does something to 'start' the heist.
function Heist:activate()
    self.available = false
    self.reset_at  = GetGameTimer() + (1000 * 60 * 15)

    TriggerClientEvent(Events.UPDATE_HEISTS, -1, {
        heists = { self }
    })

    HeistManager.wait_for_refresh()
end

function Heist:apply_damage(location, model, amount)
    local found = nil

    for _, object in ipairs(self.objects or {}) do
        if model == GetHashKey(object.model) and dist2d(location, object.location) < 0.1 and not object.broken then
            found = object
            break
        end
    end

    if not found or found.broken then
        return nil
    end

    found.damage = (found.damage or 0.0) + amount
    found.broken = true

    if self.available then
        self:activate()
    end

    return found
end

-- Only called once at resource startup
function Heist:initialize()
    self:reset()
    table.insert(heists, self)
end

-- Called any time the heist should be reset to an available state.
function Heist:reset()
    for _, spawn in ipairs(self.spawns) do
        if spawn.id then
            exports.population:RemoveSpawn(spawn.id)
        end

        spawn.id = exports.population:AddSpawn(spawn)
    end

    self.available = true

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = "Heist " .. self.id .. " at " .. self.name .. " is available."
    })
end

-- @treturns boolean true if internal state changed during the update
function Heist:update()
    if not self.available and GetGameTimer() > self.reset_at and not any_players_nearby(self) then
        self:reset()
        return true
    end

    return false
end

-- @local
function any_players_nearby(heist)
    for _, player in ipairs(GetPlayers()) do
        if dist2d(GetEntityCoords(GetPlayerPed(player)), heist.location) < heist.radius then
            return true
        end
    end

    return false
end

-- @local
function dist2d(p1, p2)
    return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
