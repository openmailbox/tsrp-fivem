RentalVehicle = {}

local HELP_KEY = "RentalsHelpMessage"

local vehicles = {}

function RentalVehicle.setup()
    AddTextEntry(HELP_KEY, "Your ~HUD_COLOUR_GREENLIGHT~rental ~BLIP_VAN_KEYS~~s~ is ready for pickup.")
end

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
    exports.map:StopEntityTracking(self.entity)
    exports.map:RemoveBlip(self.blip_id)
end

function RentalVehicle:initialize()
    self.blip_id = exports.map:StartEntityTracking(self.entity, {
        color   = 11,
        icon    = 811,
        label   = "Rental Vehicle",
        display = 2,
        flash   = 7000
    })

    table.insert(vehicles, self)

    BeginTextCommandDisplayHelp(HELP_KEY)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
