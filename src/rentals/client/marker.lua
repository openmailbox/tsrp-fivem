Marker = {}

-- Forward declarations
local show_offer,
      show_prompt

local ICON       = 810 -- radar_vehicle_for_sale
local PROMPT_KEY = "RentalVehiclePrompt"

local is_prompting = false
local markers      = {}

function Marker.all()
    return markers
end

function Marker.setup()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to rent a vehicle.")

    for name, details in pairs(RentLocations) do
        for _, cat in ipairs(details.categories) do
            for _, model in ipairs(cat.models) do
                model.label = GetDisplayNameFromVehicleModel(GetHashKey(model.name))
            end
        end

        local marker = Marker:new({
            name     = name,
            location = details.location
        })

        marker:initialize()
    end
end

function Marker.teardown()
    for _, marker in ipairs(Marker.all()) do
        marker:cleanup()
    end
end

function Marker:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Marker:initialize()
    self.blip = exports.map:AddBlip(self.location, {
        label   = "Vehicle Rental",
        icon    = ICON,
        color   = 11, -- forest green
        display = 2,
        scale   = 0.8,
    })

    self.marker = exports.markers:AddMarker({
        coords         = self.location,
        icon           = 36,
        scale          = vector3(0.3, 0.3, 0.3),
        interact_range = 1.0,
        draw_range     = 15.0,
        face_camera    = true,
        red            = 141,
        green          = 206,
        blue           = 167,
        on_interact    = function() show_offer(self.name) end,
        on_enter       = show_prompt,
        on_exit        = function()
            is_prompting = false
        end
    })

    table.insert(markers, self)
end

function Marker:cleanup()
    exports.map:RemoveBlip(self.blip)
    exports.markers:RemoveMarker(self.marker)
end

-- @local
function show_offer(name)
    if IsPedDeadOrDying(PlayerPedId(), 1) then return end

    if GetPlayerWantedLevel(PlayerId()) > 0 then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "Unable to rent a vehicle wanted by police."
        })
        return
    end

    local config = RentLocations[name]

    exports.showroom:StartSession({
        categories = config.categories,
        callback   = function(vehicle)
            print("selected " .. json.encode(vehicle or {}))
        end
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
