local function create(data)
    local player_id = source
    local container = Container.for_player(player_id)
    local removed   = container:remove_item(data.item.uuid)

    if removed then
        TriggerClientEvent(Events.UPDATE_INVENTORY_REFRESH, player_id, {
            inventory = container
        })

        TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, {
            message = "Discarded ~y~" .. removed.name .. "~s~."
        })
    end
end
RegisterNetEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, create)
