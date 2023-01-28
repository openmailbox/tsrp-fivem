StoreSafe = {}

-- Forward declarations
local access_safe

local Animation = {
    DICTIONARY = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
    NAME       = "weed_spraybottle_crouch_idle_02_inspector"
}

local MODELS = { GetHashKey("prop_ld_int_safe_01"), GetHashKey("v_ilev_gangsafedoor") }

local active_safe = {}

function StoreSafe.initialize()
    for _, model in ipairs(MODELS) do
        exports.interactions:RegisterInteraction({
            model  = model,
            name   = "Crack",
            prompt = "crack the safe"
        }, function(entity)
            exports.interactions:AddExclusion(entity)
            access_safe(entity)
            exports.interactions:RemoveExclusion(entity)
        end)
    end
end

function StoreSafe.open(id, result)
    if active_safe.lockpick_id ~= id then return end

    ClearPedTasks(PlayerPedId())

    if result == "broke" then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "Your lockpick ~r~broke~s~."
        })
    elseif result == "success" then
        TriggerServerEvent(Events.UPDATE_CRACKED_SAFE_ATTEMPT, {
            location = GetEntityCoords(PlayerPedId()),
            net_id   = ObjToNet(active_safe.entity)
        })
    end
end

-- @local
function access_safe(entity)
    NetworkRegisterEntityAsNetworked(entity)

    local net_id = ObjToNet(entity)
    local ostate = Entity(entity).state

    SetNetworkIdCanMigrate(net_id)

    if ostate.is_cracked then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, { message = "The safe was already cracked." })
        return
    elseif ostate.is_busy then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, { message = "You can't do that right now." })
        return
    end

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)

        repeat
            Citizen.Wait(10)
        until HasAnimDictLoaded(Animation.DICTIONARY)
    end

    TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.NAME, 3.0, -3.0, -1, 1, false, false, false)

    active_safe.entity      = entity
    active_safe.lockpick_id = exports.lockpicking:StartLockpicking("hard", 50)

    TriggerServerEvent(Events.CREATE_CRACKED_SAFE_ATTEMPT, {
        location = GetEntityCoords(entity),
        net_id   = net_id
    })
end
