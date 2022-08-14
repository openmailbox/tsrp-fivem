local function create()
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = Events.CREATE_WARDROBE_SESSION
    })
end
RegisterNetEvent(Events.CREATE_WARDROBE_SESSION, create)

local function delete(_, cb)
    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
