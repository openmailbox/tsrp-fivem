local function create(data)
    local success = false

    if Resupply.can_use(data.item) then
        success = Resupply.begin(data.item, data.quantity)
    end

    TriggerEvent(Events.UPDATE_INVENTORY_ITEM_USE, {
        item_uuid = data.item.uuid,
        success   = success
    })
end
AddEventHandler(Events.CREATE_INVENTORY_ITEM_USE, create)
