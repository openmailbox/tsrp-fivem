VehicleDropoff = {}

local BLIP_LABEL = "Vehicle Dropoff"

-- Active dropoff points for the player
local dropoffs = {}

function VehicleDropoff.activate(data)
    local x, y, _ = table.unpack(data.coords)
    SetNewWaypoint(x, y)

    local blip = exports.map:AddBlip(BLIP_LABEL, data.coords, {
        icon  = 524,
        color = 2
    })

    local dropoff = VehicleDropoff:new({
        blip   = blip,
        coords = data.coords,
        target = data.target
    })

    -- TODO: Show instructions

    table.insert(dropoffs, dropoff)
end

function VehicleDropoff.cleanup()
    for _, dropoff in ipairs(dropoffs) do
        dropoff:remove()
    end

    dropoffs = {}
end

function VehicleDropoff:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function VehicleDropoff:remove()
    exports.map:RemoveBlip(self.blip)
    exports.map:RemoveMarker(self.coords)
end
