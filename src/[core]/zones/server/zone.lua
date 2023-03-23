Zone = {}

local zones = {} -- Name->Zone map of all active zones on the map right now

function Zone.all()
    return zones
end

function Zone.setup()
    local count = 0

    for name, data in pairs(Zones) do
        local zone = Zone:new(data)
        zone.name = name

        zones[name] = zone

        count = count + 1
    end

    Logging.log(Logging.DEBUG, "Initialized " .. count .. " zones.")

    TriggerClientEvent(Events.UPDATE_ZONES, -1, {
        zones = zones
    })
end

function Zone.teardown()
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
    return DoesZoneContain(self, vector2(x, y)) -- shared/support
end
