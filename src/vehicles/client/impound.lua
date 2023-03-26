Impound = {}

-- Forward declarations
local show_offer,
      show_prompt

local HELP_KEY = "VehiclesImpoundHelp"

local active_impound = nil
local impounds       = {}
local is_prompting   = true

function Impound.active()
    return active_impound
end

function Impound.setup()
    AddTextEntry(HELP_KEY, "Press ~INPUT_CONTEXT~ to access the vehicle impound.")

    for name, details in pairs(Impounds) do
        local impound = Impound:new(details)

        impound.name = name
        impound:initialize()

        table.insert(impounds, impound)
    end
end

function Impound.teardown()
    for _, impound in ipairs(impounds) do
        impound:cleanup()
    end

    impounds = {}
end

function Impound:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Impound:cleanup()
    exports.map:RemoveBlip(self.blip)
    exports.markers:RemoveMarker(self.marker)
end

function Impound:initialize()
    self.blip = exports.map:AddBlip(self.location, {
        label   = "Impound",
        icon    = 380,
        color   = 6,
        display = 2
    })

    self.marker = exports.markers:AddMarker({
        coords         = self.location,
        icon           = 36,
        interact_range = 1.0,
        draw_range     = 15.0,
        scale          = vector3(0.2, 0.2, 0.2),
        face_camera    = true,
        red            = 194,
        green          = 80,
        blue           = 80,
        on_interact    = function() show_offer(self) end,
        on_enter       = show_prompt,
        on_exit        = function()
            is_prompting = false
        end
    })
end

function Impound:show_vehicles(vehicles)
    SendNUIMessage({
        type     = Events.CREATE_VEHICLE_IMPOUND_SESSION,
        vehicles = vehicles
    })

    SetNuiFocus(true, true)
end

-- @local
function show_offer(impound)
    if IsPedDeadOrDying(PlayerPedId(), 1) then return end

    if GetPlayerWantedLevel(PlayerId()) > 0 then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "Unable to access impound while wanted by police."
        })
        return
    end

    active_impound = impound

    impound:cleanup()

    exports.progress:ShowProgressBar(2000, "Checking Impound")

    TriggerServerEvent(Events.GET_IMPOUNDED_VEHICLES, {
        ui_target = GetCloudTimeAsInt() + 2000
    })
end

-- @local
function show_prompt()
    if is_prompting then return end
    is_prompting = true

    Citizen.CreateThread(function()
        while is_prompting do
            DisplayHelpTextThisFrame(HELP_KEY, 0)
            Citizen.Wait(0)
        end
    end)
end
