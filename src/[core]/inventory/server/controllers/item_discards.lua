local function create(data)
    local player_id = source
    local container = Container.for_player(player_id)
    local removed   = container and container:remove_item(data.item.uuid, data.quantity)
    local success   = (removed and true) or false

    TriggerClientEvent(Events.UPDATE_INVENTORY_ITEM_DISCARD, player_id, {
        item_uuid = removed and removed.uuid,
        item_name = removed and removed.name,
        success   = success
    })
end
RegisterNetEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, create)
