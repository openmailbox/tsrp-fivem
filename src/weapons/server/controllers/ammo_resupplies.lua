local function create(data)
    local player_id = source
    local item      = exports.inventory:RemoveItemFromPlayer(player_id, data.item.uuid, data.quantity)

    -- TODO: Equipped ammo count on open inventory session won't update until inventory is closed/reopened.
    TriggerClientEvent(Events.UPDATE_AMMO_RESUPPLY, player_id, {
        hash     = item.hash,
        quantity = data.quantity
    })
end
RegisterNetEvent(Events.CREATE_AMMO_RESUPPLY, create)
