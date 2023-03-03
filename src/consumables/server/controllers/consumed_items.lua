local function create(data)
    local player_id = source
    exports.inventory:RemoveItemFromPlayer(player_id, data.item.uuid)
end
RegisterNetEvent(Events.CREATE_CONSUMED_ITEM, create)
