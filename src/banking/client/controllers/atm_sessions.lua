local function delete(data, cb)
    Atm.stop_showing()
    cb({})
end
RegisterNUICallback(Events.DELETE_ATM_SESSION, delete)
