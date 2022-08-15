local function cmd_wardrobe(_, _, _)
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = Events.CREATE_WARDROBE_SESSION
    })
end
RegisterCommand("wardrobe", cmd_wardrobe, false)
