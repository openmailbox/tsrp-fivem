local function create(data)
    local filters = nil

    if data.filter then
        for name, details in pairs(Filters) do
            if string.lower(name) == string.lower(data.filter) then
                filters = details
                break
            end
        end
    end

    local session = Session:new({ filters = filters })
    session:initialize()
end
RegisterNetEvent(Events.CREATE_WARDROBE_SESSION, create)

local function delete(_, cb)
    local session = Session.get_active()

    if session then
        session:finish()
    end

    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
