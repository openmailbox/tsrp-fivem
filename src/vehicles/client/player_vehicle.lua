PlayerVehicle = {}

local HELP_KEY = "PlayerVehiclesHelpMessage"

local vehicles = {}

function PlayerVehicle.setup()
    AddTextEntry(HELP_KEY, "Your ~HUD_COLOUR_GREENLIGHT~vehicle ~BLIP_VAN_KEYS~~s~ is ready for pickup.")
end

function PlayerVehicle.teardown()
    for _, vehicle in ipairs(vehicles) do
        vehicle:cleanup()
    end
end

function PlayerVehicle:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PlayerVehicle:cleanup()
    exports.map:StopEntityTracking(self.entity)
    exports.map:RemoveBlip(self.blip_id)
end

function PlayerVehicle:initialize()
    local label = "Owned Vehicle"
    local color = 11

    if self.renter then
        label = "Rented Vehicle"
        color = 15
    end

    self.blip_id = exports.map:StartEntityTracking(self.entity, {
        color   = color,
        icon    = 811,
        label   = label,
        display = 2,
        flash   = 7000
    })

    table.insert(vehicles, self)

    BeginTextCommandDisplayHelp(HELP_KEY)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
