local function delete(data, cb)
    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_ATM_SESSION, delete)
