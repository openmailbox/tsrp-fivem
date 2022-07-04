-- Triggered from client-side on resource load. The initial player_id is temporary.
-- We need to update the loaded account player ID once the connection is complete.
local function update()
    local player      = source
    local identifiers = GetPlayerIdentifiers(player)
    local account     = nil

    for i in ipairs(identifiers) do
        account = Account.for_identifier(identifiers[i])
        if account ~= nil then break end
    end

    if account ~= nil then
        account:set_player_id(player)
    else
        Citizen.Trace("Unable to find an account for Player " .. player .. ".\n")
    end
end
RegisterNetEvent(Events.UPDATE_PLAYER)
AddEventHandler(Events.UPDATE_PLAYER, update)

local function create(name, _, deferrals)
    local player      = source
    local account     = Account:new(player, name)
    local environment = GetConvar("FIVEM_ENVIRONMENT", "development")

    deferrals.defer()
    Citizen.Wait(0)
    deferrals.update("Authenticating...")
    Citizen.Wait(0)

    account:reload(function(acc)
        local discord_invite = GetConvar("DISCORD_INVITE_CODE", "timeserved")
        local discord_id     = nil

        for _, ident in ipairs(acc.identifiers) do
            local match = string.match(ident.value, "^discord:(.+)")

            if match then
                discord_id = match
                break
            end
        end

        if not discord_id and not acc.whitelisted and environment ~= "production" then
            deferrals.done("Please register through our Discord: https://discord.gg/" .. discord_invite)
            return
        end

        local ban_remaining = acc:ban_time_remaining()

        if ban_remaining then
            deferrals.done("Your account has been banned. Time remaining: " .. ban_remaining)
            Citizen.Trace("Rejected account #" .. acc.id .. " due to active ban.\n")
            return
        end

        local result = discord_id and DiscordUser.for_user_id(discord_id, function(user)
            if not user then
                Citizen.Trace("No Discord user found. Falling back to accounts table whitelist check.\n")

                if acc.whitelisted or environment == "production" then
                    Queue.add(deferrals, acc)
                else
                    deferrals.done("You must be whitelisted to play on this server. Join the Discord: " ..
                                   "https://discord.gg/" .. discord_invite)
                end

                return
            end

            user.account = acc

            local has_whitelist = user:has_role(DiscordUser.ROLES.WHITELISTED)

            if has_whitelist then
                acc:update_whitelist(true)
                user:sync_permissions()
                Queue.add(deferrals, acc)
            elseif environment == "production" then
                user:sync_permissions()
                Queue.add(deferrals, acc)
            else
                acc:update_whitelist(false)
                deferrals.done("You must be whitelisted to play on this server. Join the Discord: " ..
                               "https://discord.gg/" .. discord_invite)
            end
        end)

        if result then return end

        Citizen.Trace("Unable to fetch Discord user data for account " .. tostring(acc.id) .. ". Falling back to " ..
                      "accounts table whitelist check.\n")

        if acc.whitelisted or environment == "production" then
            Queue.add(deferrals, acc)
        else
            deferrals.done("You must be whitelisted to play on this server.")
        end
    end)
end
AddEventHandler(Events.CREATE_PLAYER, create)

local function delete(reason)
    local player  = source
    local account = Account.for_player(player)

    if (account ~= nil) then
        Citizen.Trace("Unloading Account " .. account.id .. " for Player " .. player .. " w/ reason: '" ..
                      reason .. "'.\n")

        Queue.remove(account)
        account:unload()
    else
        Citizen.Trace("Player " .. player .. " disconnected without an account loaded for reason: '" .. reason .. "'.\n")
    end
end
AddEventHandler(Events.DELETE_PLAYER, delete)
