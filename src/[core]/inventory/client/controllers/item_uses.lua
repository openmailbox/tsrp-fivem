local function update(data)
    Inventory.resolve(data)
end
AddEventHandler(Events.UPDATE_INVENTORY_ITEM_USE, update)
