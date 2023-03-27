local function delete(_, cb)
    local impound = Impound.get_active()

    if impound then
        impound:initialize()
    end

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_VEHICLE_IMPOUND_SESSION, delete)
