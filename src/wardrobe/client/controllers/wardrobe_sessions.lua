local function delete(_, cb)
    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
