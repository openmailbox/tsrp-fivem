local function create(data)
    local session = Session:new(data)
    session:initialize()
end
RegisterNetEvent(Events.CREATE_INVENTORY_SESSION, create)

local function delete(_, cb)
    local session = Session.get_active()

    if session then
        session:finish()
    end

    cb({})
end
RegisterNUICallback(Events.DELETE_INVENTORY_SESSION, delete)
