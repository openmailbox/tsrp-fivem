-- Triggered from client-side on resource load. The initial player_id we get from the playerConnecting
-- event is temporary. We need to update the loaded account player ID once the connection completes.
local function create()
    local player_id   = source
    local identifiers = GetPlayerIdentifiers(player_id)
    local account     = nil

    for i in ipairs(identifiers) do
        account = Account.for_identifier(identifiers[i])
        if account ~= nil then break end
    end

    if account ~= nil then
        account:set_player_id(player_id)
    else
        Citizen.Trace("Unable to find an account for Player " .. player_id .. ".\n")
    end
end
RegisterNetEvent(Events.CREATE_ACCOUNT_SESSION, create)
