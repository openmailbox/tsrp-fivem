local function index(_)
    local player_id = source
    local account   = exports.accounts:GetPlayerAccount(player_id)

    Character.for_account(account.id, function(results)
        TriggerClientEvent(Events.UPDATE_CHARACTER_ROSTER, player_id, {
            characters = results
        })
    end)
end
RegisterNetEvent(Events.GET_CHARACTER_ROSTER, index)
