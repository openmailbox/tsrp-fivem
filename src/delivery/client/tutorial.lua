Tutorial = {}

-- Forward declarations
local update

local last_vehicle = false

function Tutorial.initialize(route)
    Citizen.CreateThread(function()
        while Route.get_active() == route do
            update()
            Citizen.Wait(1000)
        end
    end)
end

-- @local
function update()
    local route = Route.get_active()
    if not route then return end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle ~= route.vehicle then
        ClearPrints()
        BeginTextCommandPrint("STRING")
        AddTextComponentString("Enter the delivery vehicle to continue.")
        EndTextCommandPrint(1000, 0)
    elseif vehicle == route.vehicle and last_vehicle ~= vehicle then
        TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
            message =
            "Deliver packages to the ~HUD_COLOUR_NET_PLAYER5~dropoffs~BLIP_CONTRABAND~~s~ on your map.~n~Press ~INPUT_REPLAY_START_STOP_RECORDING~ to prepare a package."
        })

        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "You can only prepare packages while inside your ~h~parked~h~ delivery vehicle.",
            important = true
        })
    end

    last_vehicle = vehicle
end