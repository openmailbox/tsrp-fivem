StoreClerk = {}

-- Forward declarations
local on_enter,
      on_exit,
      on_update

local Animation = { DICTIONARY = 'mp_am_hold_up', NAME = 'holdup_victim_20s' }
local Model     = { DEFAULT = GetHashKey('prop_till_01'), BROKEN = GetHashKey('prop_till_01_dam') }
local Speech    = { VOICE = "MP_M_SHOPKEEP_01_PAKISTANI_MINI_01", TYPE = "SPEECH_PARAMS_FORCE_SHOUTED" }

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
    local register = GetClosestObjectOfType(coords, 3.0, Model.DEFAULT)

    if register == 0 or Vdist(coords, GetEntityCoords(register)) > 3.0 then
        return
    end

    -- initial state
    clerks[entity] = { ready = false }

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)
    end

    local x, y, z = table.unpack(coords)
    PlayAmbientSpeechFromPositionNative("SHOP_SCARED", Speech.VOICE, x, y, z, Speech.TYPE)

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
        if math.random() < 0.1 then
            local x, y, z = table.unpack(GetEntityCoords(entity))
            PlayAmbientSpeechFromPositionNative("SHOP_HURRYING", Speech.VOICE, x, y, z, Speech.TYPE)
        end

        return true
    else
        local x, y, z = table.unpack(GetEntityCoords(entity))
        PlayAmbientSpeechFromPositionNative("SHOP_GAVE_YOU_EVERYTHING", Speech.VOICE, x, y, z, Speech.TYPE)

        local register = GetClosestObjectOfType(x, y, z, 3.0, Model.DEFAULT)
        x, y, z        = table.unpack(GetEntityCoords(register))

        TriggerServerEvent(Events.CREATE_DAMAGED_HEIST_OBJECT, {
            victim = {
                net_id   = (NetworkGetEntityIsNetworked(register) and ObjToNet(register)) or 0,
                location = vector3(x, y, z),
                model    = Model.DEFAULT
            }
        })

        -- TODO: RemoveModelSwap somewhere
        CreateModelSwap(x, y, z, 0.2, Model.DEFAULT, Model.BROKEN, 1)

        return false
    end
end
