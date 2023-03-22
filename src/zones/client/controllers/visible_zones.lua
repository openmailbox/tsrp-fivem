local function create(_)
    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), "Showing all map zones." }
    })

    for _, zone in pairs(Zone.all()) do
        zone:show()
    end
end
RegisterNetEvent(Events.CREATE_VISIBLE_ZONES, create)

local function delete(_)
    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), "Hiding all map zones." }
    })

    for _, zone in pairs(Zone.all()) do
        zone:hide()
    end
end
RegisterNetEvent(Events.DELETE_VISIBLE_ZONES, delete)
