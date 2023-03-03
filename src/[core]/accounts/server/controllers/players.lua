local function on_connect(name, _, deferrals)
    local player_id = source

    deferrals.defer()
    Citizen.Wait(0)
    deferrals.update("Retrieving account data...")
    Citizen.Wait(0)

    Account.initialize(player_id, name, function(account, reject_reason)
        if reject_reason then
            deferrals.done(reject_reason)
            Logging.log(Logging.INFO, "Rejected Account " .. account.id .. " (" .. name .. ") with reason: '" .. reject_reason .. "'.")
            return
        end

        Queue.add(deferrals, account)
    end)
end
AddEventHandler(Events.ON_PLAYER_CONNECTING, on_connect)

local function on_disconnect(reason)
    local player_id  = source
    local account    = Account.for_player(player_id)
    local account_id = (account and account.id) or 0

    if (account ~= nil) then
        Logging.log(Logging.INFO, "Unloading Account " .. account_id .. " for Player " .. player_id .. " (" .. account.name ..
                                  "). Reason: '" .. reason .. "'.")

        Queue.remove(account)
        account:unload()
    else
        Logging.log(Logging.INFO, "Player " .. player_id .. " disconnected without an account loaded for reason: '" .. reason .. "'.")
    end
end
AddEventHandler(Events.ON_PLAYER_DROPPED, on_disconnect)
