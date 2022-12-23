local snapshot = nil

local function create(data)
    local filters = nil

    if data and data.filter then
        for name, details in pairs(Filters) do
            if string.lower(name) == string.lower(data.filter) then
                filters = details
                break
            end
        end
    end

    snapshot = PedSnapshot.record(PlayerPedId())

    local session = Session:new({ filters = filters })
    session:initialize()
end
RegisterNetEvent(Events.CREATE_WARDROBE_SESSION, create)

local function delete(data, cb)
    -- User cancelled out of the interface.
    if data.rollback then
        PedSnapshot.restore(PlayerPedId(), snapshot)
    else
        snapshot = PedSnapshot.record(PlayerPedId())
    end

    local session = Session.get_active()

    if session then
        session:finish()
    end

    local active_store = Store.get_active()

    if active_store then
        Store.enter(active_store)
    end

    TriggerEvent(Events.DELETE_WARDROBE_SESSION, {
        success  = (not data.rollback),
        snapshot = snapshot
    })

    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_SESSION, delete)
