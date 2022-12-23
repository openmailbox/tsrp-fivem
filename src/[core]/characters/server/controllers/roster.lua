local function index(_)
    local player_id = source
    local account   = exports.accounts:GetPlayerAccount(player_id)

    TriggerClientEvent(Events.UPDATE_CHARACTER_ROSTER, player_id, {
        characters = Character.for_account(account.id)
    })
end
RegisterNetEvent(Events.GET_CHARACTER_ROSTER, index)
