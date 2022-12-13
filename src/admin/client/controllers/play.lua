-- Forward declarations
local chat

local function create_anim(data)
    if not DoesAnimDictExist(data.dictionary) then
        chat("Invalid animation dictionary '" .. tostring(data.dictionary) .. "'.")
        return
    end

    if not HasAnimDictLoaded(data.dictionary) then
        RequestAnimDict(data.dictionary)

        repeat
            Citizen.Wait(100)
        until HasAnimDictLoaded(data.dictionary)
    end

    ClearPedTasks(PlayerPedId())
    TaskPlayAnim(PlayerPedId(), data.dictionary, data.animation, 8.0, 8.0, -1, 0, false, false, false)

    chat("Playing animation '" .. data.dictionary .. "/" .. data.animation .. "' for one loop.")

    while IsEntityPlayingAnim(PlayerPedId(), data.dictionary, data.animation) do
        Citizen.Wait(100)
    end

    ClearPedTasks(PlayerPedId())
end
RegisterNetEvent(Events.CREATE_ADMIN_ANIMATION, create_anim)

local function create_scenario(data)
    TaskStartScenarioInPlace(PlayerPedId(), data.scenario, -1, false)
    chat("Playing scenario '" .. data.scenario .. "'.")
end
RegisterNetEvent(Events.CREATE_ADMIN_scenario, create_scenario)

local function create_sound(data)
    PlaySoundFrontend(-1, data.name, data.set, 1)
    chat("Playing sound '" .. data.name .. "/" .. data.set .. "'.")
end
RegisterNetEvent(Events.CREATE_ADMIN_SOUND, create_sound)

local function create_speech(data)
    PlayPedAmbientSpeechNative(PlayerPedId(), data.name, "SPEECH_PARAMS_FORCE_SHOUTED")
    chat("Playing speech '" .. data.name .. "'.")
end
RegisterNetEvent(Events.CREATE_ADMIN_speech, create_speech)

-- @local
function chat(message)
    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), message }
    })
end