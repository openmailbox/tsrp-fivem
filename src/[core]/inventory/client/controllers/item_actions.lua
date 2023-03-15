local function create(data, cb)
    Inventory.process_action(data, cb)
end
RegisterNUICallback(Events.CREATE_INVENTORY_ITEM_ACTION, create)

local function update(data)
    Inventory.resolve(data.item, data.action, data.success)
end
RegisterNetEvent(Events.UPDATE_INVENTORY_ITEM_ACTION, update)
