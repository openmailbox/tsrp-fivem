local function create(data, cb)
    local session = Session.get_active()
    if not session then return end

    local active = VehiclePreview.get_active()

    if active then
        active:cleanup()
    end

    local preview = VehiclePreview:new({
        model    = data.name,
        location = Session.get_active().vehicle_location
    })

    preview:initialize()

    cb({})
end
RegisterNUICallback(Events.CREATE_SHOWROOM_PREVIEW, create)
