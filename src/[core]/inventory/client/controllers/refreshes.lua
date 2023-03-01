local function update(data)
    SendNUIMessage({
        type       = Events.UPDATE_INVENTORY_REFRESH,
        containers = data
    })
end
RegisterNetEvent(Events.UPDATE_INVENTORY_REFRESH, update)
