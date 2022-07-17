Event = {}

local events = {}

function Event.add(data)
    local event = Event:new(data)
    table.insert(events, event)
    event:show()
end

function Event.cleanup()
    for _, e in ipairs(events) do
        e:hide()
    end

    events = {}
end

function Event:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Event:hide()
    RemoveBlip(self.blip)
end

function Event:show()
    local x, y, z = table.unpack(self.location.center)
    self.blip = AddBlipForArea(x, y, z, self.location.size, self.location.size)
    SetBlipDisplay(self.blip, 3)
    SetBlipRotation(self.blip, 0)
    SetBlipColour(self.blip, 1)
    SetBlipAlpha(self.blip, 128)
end
