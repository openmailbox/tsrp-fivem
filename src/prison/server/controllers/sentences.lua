local PRISON  = vector3(1848.6707, 2586.0549, 45.6720)
local HEADING = 269.4180

local function create(_)
    local player_id = source

    TriggerClientEvent(Events.CREATE_RESPAWN, player_id, {
        location = PRISON,
        heading  = HEADING
    })

    Citizen.SetTimeout(5000, function()
        TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, {
            message = "You posted ~g~bail~s~."
        })
    end)
end
RegisterNetEvent(Events.CREATE_PRISON_SENTENCE, create)
