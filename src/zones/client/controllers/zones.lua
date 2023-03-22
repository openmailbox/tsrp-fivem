local function update(data)
    for _, z in pairs(data.zones) do
        Zone.update(z)
    end
end
RegisterNetEvent(Events.UPDATE_ZONES, update)
