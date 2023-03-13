local function create(data, cb)
    local session = Session.get_active()
    local preview = VehiclePreview.get_active()

    if preview then
        preview:cleanup()
    end

    if session then
        session:finish(data)
    end

    cb({})
end
RegisterNUICallback(Events.CREATE_SHOWROOM_VEHICLE_ACTION, create)
