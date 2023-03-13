RentalVehicle = {}

local vehicles = {}

function RentalVehicle.teardown()
    for _, vehicle in ipairs(vehicles) do
        vehicle:cleanup()
    end
end

function RentalVehicle:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function RentalVehicle:cleanup()
    exports.map:StopEntityTracking(self.self.entity)
    exports.map:RemoveBlip(self.blip_id)
end

function RentalVehicle:initialize()
    self.blip_id = exports.map:StartEntityTracking(self.entity, {
        color   = 11,
        icon    = 811,
        label   = "Rental Vehicle",
        display = 2
    })
end
