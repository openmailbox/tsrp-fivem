Depot = {}

local PROMPT_KEY = "DeliveryOfferPrompt"

-- Forward declarations
local show_prompt,
      start_route

local depots       = {}    -- list of all in-memory depots
local is_prompting = false -- loop control variable

function Depot.setup()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to deliver packages for money.")

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
        icon    = self.blip.icon,
        display = 2,
        color   = self.blip.color,
        label   = self.blip.label,
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
        on_interact    = function() start_route(self) end,
        on_enter       = show_prompt,
        on_exit        = function() is_prompting = false end
    })
end

-- @local
function show_prompt()
    if is_prompting then return end
    is_prompting = true

    Citizen.CreateThread(function()
        while is_prompting do
            DisplayHelpTextThisFrame(PROMPT_KEY, 0)
            Citizen.Wait(0)
        end
    end)
end

-- @local
function start_route(depot)
    if depot.vehicle.required then
        local vehicle = GetVehiclePedIsIn(PlayerPedId())

        if vehicle == 0 or GetVehicleClass(vehicle) ~= depot.vehicle.class then
            Tutorial.show_vehicle_requirement(depot.vehicle.class)
            return
        end
    end

    depot:cleanup()

    Route.setup(depot)
end
