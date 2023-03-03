local function create(data)
    local success = false

    if Consuming.can_consume(data.item) then
        success = Consuming.begin(data.item)
    end

    TriggerEvent(Events.UPDATE_INVENTORY_ITEM_USE, {
        item_uuid = data.item.uuid,
        success   = success
    })
end
AddEventHandler(Events.CREATE_INVENTORY_ITEM_USE, create)
