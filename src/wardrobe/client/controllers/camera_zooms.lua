local function create(data, cb)
    local session = Session.get_active()

    session.camera:start_zoom(data.direction)

    cb({})
end
RegisterNUICallback(Events.CREATE_WARDROBE_CAMERA_ZOOM, create)

local function delete(_, cb)
    local session = Session.get_active()

    session.camera:stop_zoom()

    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_CAMERA_ZOOM, delete)
