local function create()
    local session = Session:new()
    session:initialize()
end
AddEventHandler(Events.CREATE_WARDROBE_SESSION, create)

local function delete(_, cb)
    local session = Session.get_active()

    if session then
        session:finish()
    end

    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
