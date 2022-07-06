Event = {}

-- Center of a circular area
local EVENT_LOCATIONS = {
    vector3(0, 0, 0)
}

-- Never generate more than this number of events at one time
local MAX_EVENTS = 1

local STASH_MODEL = 'prop_mil_crate_01'

-- All active events on the map right now
local events = {}

function Event.check_and_init()
    if #events >= MAX_EVENTS then return end

    local location = EVENT_LOCATIONS[math.random(#EVENT_LOCATIONS)]
    local event    = Event:new({ location = location })

    table.insert(events, event)
    event:begin()
end

function Event:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Event:begin()
    local x, y, z = table.unpack(self.location)
    local stash   = CreateObject(STASH_MODEL, x, y, z, true, false, false)
end