local function update(data)
    Inventory.resolve({ uuid = data.item_uuid }, ItemActions.USE, data.success)
end
AddEventHandler(Events.UPDATE_INVENTORY_ITEM_USE, update)
