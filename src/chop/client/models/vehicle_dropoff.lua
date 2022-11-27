VehicleDropoff = {}

-- Forward declarations
local show_prompt,
      start_dropoff

local BLIP_LABEL = "Vehicle Dropoff"
local PROMPT_KEY = "StolenVehicleDropoff"

-- Active dropoff points for the player
local dropoffs = {}

local is_prompting = false

function VehicleDropoff.activate(data)
    local dropoff = VehicleDropoff:new({
        coords = data.coords,
        target = data.target
    })

    table.insert(dropoffs, dropoff)

    dropoff:reveal()
end

function VehicleDropoff.cleanup()
    for _, dropoff in ipairs(dropoffs) do
        dropoff:remove()
    end

    dropoffs = {}
end

function VehicleDropoff.initialize()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to drop off the vehicle.")
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

function VehicleDropoff:reveal()
    local x, y, _ = table.unpack(self.coords)
    SetNewWaypoint(x, y)

    self.blip = exports.map:AddBlip(BLIP_LABEL, self.coords, {
        icon  = 524,
        color = 2
    })

    self.marker = exports.markers:AddMarker({
        coords      = self.coords,
        red         = 0,
        green       = 255,
        blue        = 0,
        alpha       = 150,
        draw_range  = 12.0,
        on_enter    = show_prompt,
        on_interact = function()
            start_dropoff(self)
        end,
        on_exit     = function()
            is_prompting = false
        end
    })
end

function VehicleDropoff:tostring(_)
    local fields = {}

    for k, v in pairs(self) do
        table.insert(fields, k .. "=" .. tostring(v))
    end

    return "VehicleDropoff{" .. table.concat(fields, ", ") .. "}"
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
function start_dropoff(dropoff)
    print("Start dropoff")
end
