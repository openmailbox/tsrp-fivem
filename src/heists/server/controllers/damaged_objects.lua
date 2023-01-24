local function create(data)
    local player_id = source

    local heist = Heist.find_closest(data.victim.location)
    if not heist then return end

    local object = heist:apply_damage(data.victim.location, data.victim.model, data.damage)
    if not object then return end

    local amount = math.random(100, 500)

    TriggerClientEvent(Events.CREATE_CASH_PICKUP, player_id, {
        location = data.victim.location,
        amount   = amount
    })

    if GetPlayerWantedLevel(player_id) < 1 then
        SetPlayerWantedLevel(player_id, 1)
    end

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(player_id) .. " (" .. player_id .. ") spawned $" .. amount .. " by damaging " .. object.model .. " at " .. heist.name .. "."
    })
end
RegisterNetEvent(Events.CREATE_DAMAGED_HEIST_OBJECT, create)
