local function create()
    SendNUIMessage({
        type = Events.CREATE_WARDROBE_SESSION
    })
end
AddEventHandler(Events.CREATE_WARDROBE_SESSION, create)

local function delete(_, cb)
    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
