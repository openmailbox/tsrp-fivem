local function create(_)
    local player_id = source
    local account   = exports.accounts:GetPlayerAccount(player_id)
    local success   = true
    local message   = ''

    Character.for_account(account.id, function(characters)
        if #characters >= 2 then
            success = false
            message = "You have reached your maximum number of allowed characters."
        end

        TriggerClientEvent(Events.UPDATE_CHARACTER_AUTH_REQUEST, player_id, {
            success = success,
            message = message
        })
    end)
end
RegisterNetEvent(Events.CREATE_CHARACTER_AUTH_REQUEST, create)
