local function create(data, cb)
    local session = Session.get_active()
    local preview = VehiclePreview.get_active()

    cb({})

    if preview then
        preview:cleanup()
    end

    if session then
        session:finish(data)
    end
end
RegisterNUICallback(Events.CREATE_SHOWROOM_VEHICLE_ACTION, create)
