Zone = {}

local zones = {} -- all zones this player knows about

function Zone.add(data)
    local zone = Zone:new(data)
    table.insert(zones, zone)
    zone:show()
end

function Zone.cleanup()
    for _, z in ipairs(zones) do
        z:hide()
    end

    zones = {}
end

function Zone:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Zone:hide()
    RemoveBlip(self.blip)
end

function Zone:show()
    local x, y, z = table.unpack(self.center)
    self.blip = AddBlipForArea(x, y, z, self.width, self.height)
    SetBlipAsShortRange(self.blip, true)
    SetBlipDisplay(self.blip, 6)
    SetBlipRotation(self.blip, 0)
    SetBlipColour(self.blip, 1)
    SetBlipAlpha(self.blip, 128)
end
