-- Forward declarations
local init_session

local active      = false
local lockpick_id = 0

local function create(data)
    init_session(data.args[1], data.args[2])
end
RegisterNetEvent(Events.CREATE_LOCKPICK_SESSION, create)

local function delete(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent(Events.DELETE_LOCKPICK_SESSION, data)
    active = false
    cb({})
end
RegisterNUICallback(Events.DELETE_LOCKPICK_SESSION, delete)

-- @local
function init_session(difficulty, break_chance, details)
    active      = true
    lockpick_id = lockpick_id + 1

    SendNUIMessage({
        type            = Events.CREATE_LOCKPICK_SESSION,
        passedData      = details,
        difficulty      = difficulty,
        id              = lockpick_id,
        pickBreakChance = break_chance
    })

    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
        local scaleform = CreateInstructionalDisplay("Bump Pin", 22, "Lock Pin", 24)

        while active do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Citizen.Wait(0)
        end
    end)

    return lockpick_id
end
exports("StartLockpicking", init_session)
