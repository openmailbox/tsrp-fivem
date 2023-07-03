Dropoff = {}

local PROMPT_KEY = "DeliveryDropoffPrompt"

-- Forward declarations
local attempt_delivery,
      show_prompt

local is_prompting = false

function Dropoff.setup()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to deliver the package.")
end

function Dropoff:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Dropoff:cleanup()
    exports.map:RemoveBlip(self.blip_id)
    exports.markers:RemoveMarker(self.marker_id)
end

function Dropoff:initialize()
    self.blip_id = exports.map:AddBlip(self.coords, {
        icon    = 478,
        display = 2,
        color   = 10,
        label   = "Package Dropoff",
    })

    self.marker_id = exports.markers:AddMarker({
        icon        = 1,
        coords      = self.coords,
        draw_range  = 15.0,
        red         = 255,
        green       = 255,
        blue        = 0,
        alpha       = 100,
        on_interact = function() attempt_delivery(self) end,
        on_enter    = show_prompt,
        on_exit     = function()
            is_prompting = false
        end
    })
end

-- @local
function attempt_delivery(dropoff)
    if not Route.has_package() then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message   = "You are not carrying a package. Return to your delivery vehicle.",
            important = true
        })
        return
    end

    Route.remove_package()
    dropoff:cleanup()

    -- TODO: If it's the last dropoff, finish route

    if exports["rpemotes"] then
        exports["rpemotes"]:EmoteCancel()
    end

    TriggerServerEvent(Events.CREATE_DELIVERY_PACKAGE_DROPOFF)
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
