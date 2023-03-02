local function create(data, cb)
    TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, data)
    cb({})
end
RegisterNUICallback(Events.CREATE_INVENTORY_ITEM_DISCARD, create)
