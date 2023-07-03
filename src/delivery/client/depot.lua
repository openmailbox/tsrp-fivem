Depot = {}

local PROMPT_KEY = "DeliveryOfferPrompt"

local depots = {}

function Depot.setup()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to check the list.")

    for name, details in pairs(DeliveryRoutes) do
        local depot = Depot:new(details)

        depot.name = name
        depot:initialize()

        table.insert(depots, depot)
    end
end

function Depot.teardown()
    for _, depot in ipairs(depots) do
        depot:cleanup()
    end
end

function Depot:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Depot:cleanup()
    exports.map:RemoveBlip(self.blip_id)
    exports.markers:RemoveMarker(self.marker_id)
end

function Depot:initialize()
    local x, y, z, _ = table.unpack(self.origin)
    local location   = vector3(x, y, z)

    self.blip_id = exports.map:AddBlip(location, {
        icon    = 478,
        display = 2,
        color   = 10,
        label   = "Delivery Depot",
        scale   = vector3(1.2, 1.2, 1.2)
    })

    self.marker_id = exports.markers:AddMarker({
        icon           = 32,
        coords         = location,
        red            = 255,
        green          = 255,
        face_camera    = true,
        scale          = vector3(0.2, 0.2, 0.2),
        blue           = 0,
        interact_range = 1.0,
        draw_range     = 20.0,
        on_interact    = function() print("interact") end,
        on_enter       = function() print("enter") end,
        on_exit        = function() print("exit") end
    })
end
