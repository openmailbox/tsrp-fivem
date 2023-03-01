local function create()
    local player_id = source
    local container = Container.for_player(player_id)

    TriggerClientEvent(Events.UPDATE_INVENTORY_REFRESH, player_id, {
        inventory = container
    })
end
RegisterNetEvent(Events.CREATE_INVENTORY_REFRESH, create)
