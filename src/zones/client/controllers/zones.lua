local function create(data)
    for _, z in pairs(data.zones) do
        Zone.add(z)
    end
end
RegisterNetEvent(Events.CREATE_ZONES, create)

local function update(data)
    Zone.cleanup()

    for _, z in pairs(data.zones) do
        Zone.add(z)
    end
end
RegisterNetEvent(Events.UPDATE_ZONES, update)
