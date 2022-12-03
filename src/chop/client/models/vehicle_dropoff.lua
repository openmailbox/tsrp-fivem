VehicleDropoff = {}

-- Forward declarations
local chat,
      show_prompt,
      start_dropoff

local PROMPT_KEY = "StolenVehicleDropoff"

-- Active dropoff points for the player
local dropoffs = {}

local is_prompting = false

function VehicleDropoff.activate(data)
    local dropoff = VehicleDropoff:new({
        delivery = data.delivery, -- vector3
        model    = data.model,    -- result of GetHashKey()
        name     = data.name,     -- result of GetDisplayNameFromVehicleModel()
        label    = data.label     -- result of GetLabelText()
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
    exports.map:RemoveBlip(self.blip_id)
    exports.markers:RemoveMarker(self.marker)
end

function VehicleDropoff:reveal()
    self.blip_id = exports.map:AddBlip(self.delivery, {
        icon  = 524,
        color = 6,
        label = "Vehicle Dropoff"
    })

    self.marker = exports.markers:AddMarker({
        coords      = self.delivery,
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

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "Deliver one ~y~" .. self.label .. "~s~ to the marked ~HUD_COLOUR_REDLIGHT~Vehicle Dropoff~s~ on your GPS.",
        sender  = {
            image   = "CHAR_BLOCKED",
            name    = "Blocked",
            subject = "Encrypted Message"
        }
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
function chat(message)
    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { "GAME", message }
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
function start_dropoff(dropoff)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        chat("Not in a vehicle.")
        return
    end

    local driver = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)

    if driver ~= PlayerPedId() then
        chat("Must be driving the vehicle.")
        return
    end

    exports.progress:ShowProgressBar(2000, "Checking Vehicle")

    local model = GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))
    local name  = GetDisplayNameFromVehicleModel(model)
    local label = GetLabelText(name)

    TriggerServerEvent(Events.CREATE_CHOP_VEHICLE_DROPOFF, {
        dropoff = dropoff,
        vehicle = {
            model = model,
            name  = name,
            label = label
        }
    })
end
