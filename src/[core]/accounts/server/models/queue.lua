Queue = {}

-- whatever the max player count should be before queue goes into effect
local MAX_PLAYERS = 64

-- Forward declarations
local process_queue

local ellipsis = "."
local running  = false
local queue    = {}

--- Main entry point for the queue. Either allows the connection to proceed or queue it.
-- @tparam table defferals the deferral object handed off from playerConnecting
-- @tparam Account account
function Queue.add(deferrals, account)
    local online   = GetPlayers()
    local count    = #online
    local position = #queue + 1

    if count < MAX_PLAYERS then
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

    Citizen.Trace("Adding Account #" .. account.id .. "(" .. tostring(account.name) .. ") to the queue in position " .. position .. ".\n")

    if not running then Queue.start_check() end
end

--- Remove the account from the queue if the player dropped before connecting
-- @tparam Account account
function Queue.remove(account)
    if not running then return end

    for i, waiting in ipairs(queue) do
        if waiting.account.id == account.id then
            table.remove(waiting, i)
            return
        end
    end
end

function Queue.start_check()
    ellipsis = "."
    running  = true

    Citizen.CreateThread(function()
        while running do
            if #queue == 0 then
                running = false
                break
            end

            process_queue()

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
function process_queue()
    local online = GetPlayers()
    local spaces = MAX_PLAYERS - #online

    if spaces > 0 and #queue > 0 then
        for _ = 1, spaces do
            local waiting = queue[1]

            table.remove(queue, 1)

            waiting.deferrals.done()
            Citizen.Trace("Pulling Account #" .. waiting.account.id .. "(" .. tostring(waiting.account.name) .. ") from queue and connecting.\n")
        end
    end

    local removing = {}

    for i, waiting in ipairs(queue) do
        local guid = GetPlayerGuid(waiting.account.player_id)

        if guid then
            waiting.deferrals.update("You are in queue at position " .. i .. " of " .. #queue .. ellipsis)
        else
            Citizen.Trace("Account #" .. waiting.account.id .. "(" .. tostring(waiting.account.name) ..  ") dropped from the queue.\n")
            table.insert(removing, i)
        end
    end

    for _, index in ipairs(removing) do
        table.remove(queue, index)
    end
end
