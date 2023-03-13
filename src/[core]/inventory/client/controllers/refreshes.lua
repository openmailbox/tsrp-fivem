local function update(data)
    if not Session.get_active() then return end
    Inventory.refresh(data)
end
RegisterNetEvent(Events.UPDATE_INVENTORY_REFRESH, update)
