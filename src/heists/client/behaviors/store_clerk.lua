StoreClerk = {}

-- Forward declarations
local on_enter,
      on_exit,
      on_update

local Animation = { DICTIONARY = 'mp_am_hold_up', NAME = 'holdup_victim_20s' }
local MODEL     = GetHashKey('prop_till_01')

local clerks = {}

function StoreClerk.cleanup()
    exports.hostages:RemoveBehavior("store_clerk")
end

function StoreClerk.initialize()
    exports.hostages:AddBehavior("store_clerk", {
        name      = "Rob Store",
        prompt    = "rob the store clerk",
        on_enter  = on_enter,
        on_exit   = on_exit,
        on_update = on_update
    })
end

-- @local
function on_enter(entity)
    local coords   = GetEntityCoords(entity)
    local register = GetClosestObjectOfType(coords, 3.0, MODEL)

    if register == 0 or Vdist(coords, GetEntityCoords(register)) > 3.0 then
        return
    end

    -- initial state
    clerks[entity] = { ready = false }

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)
    end

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Started robbing Store Clerk at " .. coords .. "."
    })

    local turn_to = GetOffsetFromEntityInWorldCoords(register, 0.5, 0.0, 0.0)
    TaskTurnPedToFaceCoord(entity, turn_to, -1)

    Citizen.CreateThread(function()
        local v, w, angle, degrees

        repeat
            v       = GetEntityForwardVector(entity)
            w       = norm(turn_to - GetEntityCoords(entity))
            angle   = math.atan2((w.y * v.x) - (w.x * v.y), (w.x * v.x) + (w.y * v.y))
            degrees = angle * 180 / math.pi

            Citizen.Wait(100)
        until degrees > -20 and degrees < 20

        while not HasAnimDictLoaded(Animation.DICTIONARY) do
            Citizen.Wait(10)
        end

        TaskPlayAnim(entity, Animation.DICTIONARY, Animation.NAME, 8.0, -8.0, -1, 0, 0, false, false, false)
        PlayAmbientSpeech1(entity, "SHOP_HURRYING", "SPEECH_PARAMS_FORCE_SHOUTED", 0)

        clerks[entity].ready = true
    end)
end

-- @local
function on_exit(entity)
    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Finished robbing Store Clerk at " .. GetEntityCoords(entity) .. "."
    })
end

-- @local
function on_update(entity)
    local clerk = clerks[entity]

    if not clerk or IsPedDeadOrDying(entity, 1) then
        return false
    end

    if not clerk.ready or IsEntityPlayingAnim(entity, Animation.DICTIONARY, Animation.NAME, 3) then
        return true
    else
        PlayAmbientSpeech1(entity, "SHOP_GAVE_YOU_EVERYTHING", "SPEECH_PARAMS_FORCE_SHOUTED", 0)

        TriggerEvent(Events.CREATE_CASH_PICKUP, {
            location = (GetEntityCoords(entity) + GetEntityForwardVector(entity)),
            amount   = math.random(100, 500)
        })

        return false
    end

    -- TODO: If register was destroyed, bail
end
