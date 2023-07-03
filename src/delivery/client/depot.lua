Depot = {}

local POSTAL_DEPOT = vector4(68.7993, 127.2573, 79.2058, 156.0530)
local PROMPT_KEY   = "DeliveryOfferPrompt"

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
end

function Depot:initialize()
    self.blip_id = exports.map:AddBlip(POSTAL_DEPOT, {
        icon    = 478,
        display = 2,
        color   = 10,
        label   = "Delivery Depot",
        scale   = vector3(1.2, 1.2, 1.2)
    })
end
