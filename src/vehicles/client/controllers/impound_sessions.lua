local function delete(data, cb)
    print(json.encode(data))
    cb({})
end
RegisterNUICallback(Events.DELETE_VEHICLE_IMPOUND_SESSION, delete)
