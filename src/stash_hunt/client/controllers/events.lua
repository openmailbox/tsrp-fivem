local function create(data)
    for _, d in ipairs(data.events) do
        Event.add(d)
    end
end
RegisterNetEvent(Events.CREATE_STASH_EVENTS, create)
