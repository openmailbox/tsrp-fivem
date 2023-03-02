local function create()
    local player_id = source
    local names     = {}

    for name, _ in pairs(ConsumableItems) do
        table.insert(names, name)
    end

    local chosen = names[math.random(#names)]

    exports.inventory:GiveItemToPlayer(player_id, chosen)

    TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, {
        flash   = false,
        message = "You found a discarded ~y~" .. chosen .. "~s~."
    })
end
RegisterNetEvent(Events.CREATE_CONSUMABLES_REWARD, create)
