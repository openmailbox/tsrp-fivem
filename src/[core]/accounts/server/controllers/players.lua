local function on_connect(name, _, deferrals)
    local player_id = source

    deferrals.defer()
    Citizen.Wait(0)
    deferrals.update("Retrieving account data...")
    Citizen.Wait(0)

    Account.initialize(player_id, name, function(account, reject_reason)
        if reject_reason then
            deferrals.done(reject_reason)
            Citizen.Trace("Rejected Account " .. account.id .. " (" .. name .. ") with reason: '" .. reject_reason .. "'.\n")
            return
        end

        Queue.add(deferrals, account)
    end)
end
AddEventHandler(Events.ON_PLAYER_CONNECTING, on_connect)

local function on_disconnect(reason)
    local player_id = source
    local account   = Account.for_player(player_id)

    if (account ~= nil) then
        Citizen.Trace("Unloading Account " .. account.id .. " for Player " .. player_id .. " w/ reason: '" .. reason .. "'.\n")
        Queue.remove(account)
        account:unload()
    else
        Citizen.Trace("Player " .. player_id .. " disconnected without an account loaded for reason: '" .. reason .. "'.\n")
    end
end
AddEventHandler(Events.ON_PLAYER_DROPPED, on_disconnect)
