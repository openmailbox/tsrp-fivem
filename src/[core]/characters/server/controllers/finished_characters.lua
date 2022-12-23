local function create(data)
    local player_id = source
    local account   = exports.accounts:GetPlayerAccount(player_id)

    TriggerClientEvent(Events.UPDATE_FINISHED_CHARACTER, player_id)
end
RegisterNetEvent(Events.CREATE_FINISHED_CHARACTER, create)
