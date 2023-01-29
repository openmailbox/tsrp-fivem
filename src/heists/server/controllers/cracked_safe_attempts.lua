local function create(data)
    local player_id = source
    local heist     = Heist.find_closest(data.location)
    local entity    = NetworkGetEntityFromNetworkId(data.net_id)

    Entity(entity).state.is_busy = true

    if heist then
        heist:activate()

        if GetPlayerWantedLevel(player_id) < 1 then
            SetPlayerWantedLevel(player_id, 1)
        end
    end

    local name = (heist and heist.name) or "Unknown"

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(player_id) .. " (" .. player_id .. ") started cracking a safe at " .. data.location .. " (" .. name .. ")."
    })
end
RegisterNetEvent(Events.CREATE_CRACKED_SAFE_ATTEMPT, create)

local function update(data)
    local player_id = source
    local heist     = Heist.find_closest(data.location)
    local entity    = NetworkGetEntityFromNetworkId(data.net_id)
    local ostate    = Entity(entity).state

    ostate.is_busy = false

    if data.result ~= "success" then return end

    ostate.is_cracked = true

    local amount = math.random(500, 2000)

    TriggerClientEvent(Events.CREATE_CASH_PICKUP, player_id, {
        location = data.location,
        amount   = amount
    })

    local name = (heist and heist.name) or "Unknown"

    if heist then
        heist:crack_safe(entity)
    end

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(player_id) .. " (" .. player_id .. ") spawned $" .. amount .. " by cracking a safe at " .. data.location .. " (" .. name .. ")."
    })
end
RegisterNetEvent(Events.UPDATE_CRACKED_SAFE_ATTEMPT, update)
