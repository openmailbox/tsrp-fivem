Heist = {}

-- Forward declarations
local dist2d

local heists = {}

function Heist.all()
    return heists
end

function Heist.cleanup()
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

    return found
end

function Heist:initialize()
    self.available = true
    table.insert(heists, self)
end

-- @local
function dist2d(p1, p2)
    return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
