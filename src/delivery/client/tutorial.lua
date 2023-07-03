Tutorial = {}

function Tutorial.drop_package()
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentString("Deliver the package at the dropoff.")
    EndTextCommandPrint(1000, 0)
end

function Tutorial.enter_vehicle()
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentString("Enter the delivery vehicle to continue.")
    EndTextCommandPrint(1000, 0)
end

function Tutorial.show_instructions()
    TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
        message = "Deliver packages to the ~HUD_COLOUR_NET_PLAYER5~dropoffs~BLIP_CONTRABAND~~s~ on your map.~n~Press ~INPUT_DETONATE~ to prepare a package."
    })

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message   = "You can only prepare packages while inside your ~h~parked~h~ delivery vehicle.",
        important = true
    })
end
