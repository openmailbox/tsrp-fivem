Zone = {}

local zones = {} -- Name->Zone map of all active zones on the map right now

function Zone.all()
    return zones
end

function Zone.initialize()
    local count = 0

    for name, data in pairs(Zones) do
        local zone = Zone:new(data)

        zones[name] = zone

        count = count + 1
    end

    Citizen.Trace("Created " .. count .. " zones.\n")

    TriggerClientEvent(Events.UPDATE_ZONES, -1, {
        zones = zones
    })
end

function Zone.cleanup()
    zones = {}
end

function Zone.from_point(x, y)
    local matches = {}

    for _, zone in pairs(zones) do
        if zone:contains(x, y) then
            table.insert(matches, zone)
        end
    end

    return matches
end

function Zone:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Zone:contains(x, y)
    local x_min = self.center.x - (self.width / 2)
    local x_max = self.center.x + (self.width / 2)

    if x < x_min or x > x_max then
        return false
    end

    local y_min = self.center.y - (self.height / 2)
    local y_max = self.center.y + (self.height / 2)

    if y < y_min or y > y_max then
        return false
    end

    return true
end
