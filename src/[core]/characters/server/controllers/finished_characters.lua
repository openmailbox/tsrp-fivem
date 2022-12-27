local function create(data)
    local player_id = source
    local account   = exports.accounts:GetPlayerAccount(player_id)

    local character = Character:new({
        account_id = account.id,
        snapshot   = data.snapshot,
        first_name = data.first_name,
        last_name  = data.last_name,
    })

    character:save(function(char)
        TriggerClientEvent(Events.UPDATE_FINISHED_CHARACTER, player_id)

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.INFO,
            message = "Created new character '" .. data.first_name .. " " .. data.last_name .. "' (" .. char.id .. ") for " .. GetPlayerName(player_id) .. " (" .. player_id .. ")."
        })
    end)
end
RegisterNetEvent(Events.CREATE_FINISHED_CHARACTER, create)
