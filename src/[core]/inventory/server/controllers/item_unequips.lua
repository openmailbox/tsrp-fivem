local function create(data)
    local player_id = source
    local container = Container.for_player(player_id)
    local template  = ItemTemplate.for_name(data.item.name)
    local new_item  = template and Item.from_template(template)

    if new_item then
        container:add_item(new_item)
    else
        Logging.log(Logging.WARN, "Unable to find item template for '" .. data.item.name .. "' to unequip weapon from Player " .. player_id .. ".")
    end

    TriggerClientEvent(Events.UPDATE_INVENTORY_ITEM_ACTION, player_id, {
        item    = data.item,
        action  = ItemActions.UNEQUIP,
        success = true
    })

    -- TODO: We end up w/ a race condition if weapon removal doesn't go through prior to inventory refresh.
    -- Might need to trigger refresh from client-side detection that something changed (i.e. weapon removal)
    RemoveWeaponFromPed(GetPlayerPed(player_id), data.weapon_hash)
    Citizen.Wait(GetPlayerPing(player_id))

    TriggerClientEvent(Events.UPDATE_INVENTORY_REFRESH, player_id, {
        inventory = container
    })
end
RegisterNetEvent(Events.CREATE_INVENTORY_ITEM_UNEQUIP, create)
