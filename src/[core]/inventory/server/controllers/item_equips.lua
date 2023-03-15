local function create(data)
    local player_id = source
    local container = Container.for_player(player_id)
    local item      = container:remove_item(data.item.uuid)

    if not item then
        Logging.log(Logging.WARN, "Unable to remove item " .. data.item.uuid .. " from Player " .. player_id .. "'s inventory.")
        return
    end

    TriggerClientEvent(Events.UPDATE_INVENTORY_ITEM_ACTION, player_id, {
        item    = item,
        action  = ItemActions.EQUIP,
        success = true
    })

    -- TODO: We end up w/ a race condition if weapon give doesn't go through prior to inventory refresh.
    -- Might need to trigger refresh from client-side detection that something changed (i.e. weapon removal)
    GiveWeaponToPed(GetPlayerPed(player_id), data.weapon_hash, 0, false, true)
    Citizen.Wait(GetPlayerPing(player_id))

    TriggerClientEvent(Events.UPDATE_INVENTORY_REFRESH, player_id, {
        inventory = container
    })
end
RegisterNetEvent(Events.CREATE_INVENTORY_ITEM_EQUIP, create)
