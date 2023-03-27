local function delete(data, cb)
    print(json.encode(data))

    local impound = Impound.active()
    impound:initialize()

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_VEHICLE_IMPOUND_SESSION, delete)
