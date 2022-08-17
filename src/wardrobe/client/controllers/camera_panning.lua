local function create(data, cb)
    local session = Session.get_active()

    session.camera:start_panning(data.direction)

    cb({})
end
RegisterNUICallback(Events.CREATE_WARDROBE_CAMERA_PAN, create)

local function delete(_, cb)
    local session = Session.get_active()

    session.camera:stop_panning()

    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_CAMERA_PAN, delete)
