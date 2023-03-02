local function update(data)
    if not Session.get_active() then return end

    SendNUIMessage({
        type       = Events.UPDATE_INVENTORY_REFRESH,
        containers = data
    })
end
RegisterNetEvent(Events.UPDATE_INVENTORY_REFRESH, update)
