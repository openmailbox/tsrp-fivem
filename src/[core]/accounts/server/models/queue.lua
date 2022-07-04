Queue = {}

local MAX_WHITELIST_PLAYERS = GetConvarInt("MAX_WHITELIST_PLAYERS", 64)
local MAX_PUBLIC_PLAYERS    = GetConvarInt("MAX_PUBLIC_PLAYERS", 30)

-- Forward declarations
local process_queue

local ellipsis        = "."
local running         = false
local queue_public    = {}
local queue_whitelist = {}

--- Main entry point for the queue. Either allows the connection to proceed or queue it.
-- @tparam table defferals the deferral object handed off from playerConnecting
-- @tparam Account account
function Queue.add(deferrals, account)
    local online = GetPlayers()
    local count  = #online
    local queue  = queue_public
    local limit  = MAX_PUBLIC_PLAYERS
    local label  = "public"

    if account.whitelisted then
        queue = queue_whitelist
        limit = MAX_WHITELIST_PLAYERS
        label = "whitelist"
    end

    local position = #queue + 1

    if count < limit then
        deferrals.done()
        return
    end

    local waiting = {
        deferrals = deferrals,
        account   = account
    }

    for i, q in ipairs(queue) do
        if q.account.priority < account.priority then
            position = i
        end
    end

    table.insert(queue, position, waiting)

    local message = "Adding Account #" .. account.id .. "(" .. tostring(account.name) .. ") to the " .. label ..
                    " queue in position " .. position .. "."

    Citizen.Trace(message .. "\n")
    TriggerEvent(Events.CREATE_DISCORD_LOG, message)

    if not running then Queue.start_check() end
end

--- Remove the account from the queue if the player dropped before connecting
-- @tparam Account account
function Queue.remove(account)
    if not running then return end

    for i, waiting in ipairs(queue_whitelist) do
        if waiting.account.id == account.id then
            table.remove(queue_whitelist, i)
            return
        end
    end

    for i, waiting in ipairs(queue_public) do
        if waiting.account.id == account.id then
            table.remove(queue_public, i)
            return
        end
    end
end

function Queue.start_check()
    ellipsis = "."
    running  = true

    Citizen.CreateThread(function()
        while running do
            if #queue_whitelist == 0 and #queue_public == 0 then
                running = false
                break
            end

            process_queue("whitelist", queue_whitelist, MAX_WHITELIST_PLAYERS)
            process_queue("public", queue_public, MAX_PUBLIC_PLAYERS)

            if string.len(ellipsis) == 3 then
                ellipsis = "."
            else
                ellipsis = ellipsis .. "."
            end

            Citizen.Wait(5000)
        end
    end)
end

-- @local
function process_queue(label, queue, limit)
    local online   = GetPlayers()
    local spaces   = limit - #online

    if spaces > 0 and #queue > 0 then
        for _ = 1, spaces do
            local waiting = queue[1]

            table.remove(queue, 1)

            waiting.deferrals.done()
            Citizen.Trace("Removing Account #" .. waiting.account.id .. "(" .. tostring(waiting.account.name) ..
                          ") from " .. label .. " queue and connecting.\n")
        end
    end

    local removing = {}

    for i, waiting in ipairs(queue) do
        local guid = GetPlayerGuid(waiting.account.player_id)

        if guid then
            waiting.deferrals.update("You are in the " .. label .. " queue at position " .. i ..
                                     " of " .. #queue .. ellipsis)
        else
            Citizen.Trace("Account #" .. waiting.account.id .. "(" .. tostring(waiting.account.name) ..
                          ") dropped from the " .. label .. " queue.\n")
            table.insert(removing, i)
        end
    end

    for _, index in ipairs(removing) do
        table.remove(queue, index)
    end
end
