local function create(data, cb)
    Inventory.process_action(data, cb)
end
RegisterNUICallback(Events.CREATE_INVENTORY_ITEM_ACTION, create)
