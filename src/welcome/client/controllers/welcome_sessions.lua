local function delete(data, cb)
    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_WELCOME_SESSION, delete)
