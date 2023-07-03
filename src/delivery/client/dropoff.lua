Dropoff = {}

local PROMPT_KEY = "DeliveryDropoffPrompt"

-- Forward declarations
local attach_package,
      attempt_delivery,
      play_emote,
      show_prompt

local is_active    = false
local is_prompting = false

function Dropoff.activate()
    attach_package()
end

function Dropoff.deactivate()
    is_active = false
end

function Dropoff.is_active()
    return is_active
end

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
    if not is_active then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message   = "You are not carrying a package. Return to your delivery vehicle.",
            important = true
        })
        return
    end

    is_active = false

    dropoff.completed = true
    dropoff:cleanup()
    dropoff.route:checkpoint()

    if exports["rpemotes"] then
        exports["rpemotes"]:EmoteCancel()
    end

    TriggerServerEvent(Events.CREATE_DELIVERY_PACKAGE_DROPOFF, {})
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
function attach_package()
    TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 256)

    Citizen.CreateThread(function()
        repeat
            Citizen.Wait(100)
        until not IsPedInAnyVehicle(PlayerPedId(), false)

        is_active = true

        play_emote()
    end)
end

-- @local
function play_emote()
    -- Avoid making the emote resource a hard dependency so we can easily swap out for whatever emote provider.
    if exports["rpemotes"] then
        exports["rpemotes"]:EmoteCommandStart("box")
    else
        Logging.log(Logging.WARN, "Unable to attach box via emote.")
    end
end
