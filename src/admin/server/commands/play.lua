-- Forward declarations
local log

local function cmd_play_anim(source, args, raw_command)
    local player_id = source

    TriggerClientEvent(Events.CREATE_ADMIN_ANIMATION, player_id, {
        dictionary = args[1],
        animation  = args[2]
    })

    log(player_id, raw_command)
end
RegisterCommand("playanim", cmd_play_anim, true)

local function cmd_play_scenario(source, args, raw_command)
    local player_id = source

    TriggerClientEvent(Events.CREATE_ADMIN_SCENARIO, player_id, {
        scenario = args[1]
    })

    log(player_id, raw_command)
end
RegisterCommand("playscenario", cmd_play_scenario, true)

local function cmd_play_sound(source, args, raw_command)
    local player_id = source

    TriggerClientEvent(Events.CREATE_ADMIN_SOUND, player_id, {
        name = args[1],
        set  = args[2]
    })

    log(player_id, raw_command)
end
RegisterCommand("playsound", cmd_play_sound, true)

local function cmd_play_speech(source, args, raw_command)
    local player_id = source

    TriggerClientEvent(Events.CREATE_ADMIN_SPEECH, player_id, {
        name = args[1]
    })

    log(player_id, raw_command)
end
RegisterCommand("playspeech", cmd_play_speech, true)

-- @local
function log(player_id, command)
    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.INFO,
        message = GetPlayerName(player_id) .. " (" .. player_id .. ") used command '" .. command .. "'."
    })
end
