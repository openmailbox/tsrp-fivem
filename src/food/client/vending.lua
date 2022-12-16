Vending = {}

-- Forward declarations
local approach_machine,
      begin_purchase,
      buy_drink,
      check_and_continue,
      consume_drink,
      listen_for_cancel,
      load_model,
      release_resources,
      restore_health,
      toss_drink

local ANIMATIONS    = { "plyr_buy_drink_pt1", "plyr_buy_drink_pt2", "plyr_buy_drink_pt3" }
local DICTIONARY    = "mini@sprunk"
local INTERACT_NAME = "Pay $2 for Soda"
local CAN_MODEL     = GetHashKey("prop_ecola_can")
local PRICE         = 2

local funds     = 0
local cancelled = false
local models    = {}

function Vending.authorize(amount)
    if not amount then
        cancelled = true
    else
        funds = funds + amount
    end
end

function Vending.cleanup()
    for _, model in ipairs(Objects.SODA_MACHINES) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end
end

function Vending.initialize()
    for _, model in ipairs(Objects.SODA_MACHINES) do
        table.insert(models, model)

        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = string.lower(INTERACT_NAME),
        }, begin_purchase)
    end

    return models
end

-- @local
function approach_machine(object)
    local ped      = PlayerPedId()
    local position = GetOffsetFromEntityInWorldCoords(object, 0.0, -0.97, 0.05)
    local timeout  = GetGameTimer() + 3000

    if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
        TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(object), 0.1)

        while not cancelled and not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) and GetGameTimer() < timeout do
            Citizen.Wait(50)
        end
    end
end

-- Blocks the thread it runs in.
-- @local
function begin_purchase(object)
    exports.interactions:AddExclusion(object)

    TriggerServerEvent(Events.CREATE_FOOD_CHARGE_AUTH, {
        amount = PRICE
    })

    listen_for_cancel()

    LoadAnimDictionary(DICTIONARY)
    RequestAmbientAudioBank("VENDING_MACHINE")
    HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
    load_model(CAN_MODEL)

    approach_machine(object)
    if not check_and_continue(nil, object) then return end

    TurnToward(GetEntityCoords(object))

    local progress = exports.progress:ShowProgressBar(11500, "Buying Drink")
    local can      = buy_drink()

    if not check_and_continue(progress, object, can) then return end
    consume_drink()
    if not check_and_continue(progress, object, can) then return end
    toss_drink(can)

    exports.progress:CancelProgressBar(progress)
    release_resources(object, can)

    cancelled = true -- stops the listen check
    funds     = funds - PRICE

    TriggerServerEvent(Events.UPDATE_FOOD_CHARGE_AUTH, {
        amount = PRICE
    })

    -- TODO: Kat to implement random chance the machine eats your dollar
    restore_health()
end

-- @local
function buy_drink()
    local ped      = PlayerPedId()
    local position = GetEntityCoords(ped) + (GetEntityForwardVector(ped) + vector3(0, 0.1, 0))

    TaskPlayAnim(ped, DICTIONARY, ANIMATIONS[1], 8.0, 5.0, -1, 0, false, false, false)
    Citizen.Wait(2500)

    local can = CreateObjectNoOffset(CAN_MODEL, position, true, false, false)
    SetEntityAsMissionEntity(can, true, true)
    SetEntityProofs(can, false, true, false, false, false, false, 0, false)
    AttachEntityToEntity(can, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

    repeat
        Citizen.Wait(0)
    until cancelled or not IsEntityPlayingAnim(ped, DICTIONARY, ANIMATIONS[1], 3)

    return can
end

-- @local
function check_and_continue(progress, object, can)
    if cancelled then
        exports.progress:CancelProgressBar(progress)
        release_resources(object, can)
        return false
    else
        return true
    end
end

-- @local
function consume_drink()
    local ped = PlayerPedId()

    TaskPlayAnim(ped, DICTIONARY, ANIMATIONS[2], 8.0, 5.0, -1, 0, false, false, false)

    repeat
        Citizen.Wait(0)
    until cancelled or not IsEntityPlayingAnim(ped, DICTIONARY, ANIMATIONS[2], 3)
end

-- @local
function listen_for_cancel()
    cancelled = false

    Citizen.CreateThread(function()
        while not cancelled do
            if IsControlJustPressed(0, 73) then
                cancelled = true
            end

            Citizen.Wait(0)
        end
    end)
end

-- @local
function load_model(model)
    if not HasModelLoaded(model) then
        RequestModel(model)

        repeat
            Citizen.Wait(50)
        until HasModelLoaded(model)
    end
end

-- @local
function release_resources(object, can)
    if can and DoesEntityExist(can) then
        DetachEntity(can, true, true)
        DeleteEntity(can)
    end

    ClearPedTasks(PlayerPedId())
    SetModelAsNoLongerNeeded(CAN_MODEL)
    ReleaseAmbientAudioBank()
    RemoveAnimDict(DICTIONARY)

    exports.interactions:RemoveExclusion(object)
end

-- @local
function restore_health()
    local original = GetPlayerHealthRechargeLimit(PlayerId())
    local target   = math.max(1.0, original + 0.5)

    SetPlayerHealthRechargeLimit(PlayerId(), target)
    Citizen.Wait(10000)
    SetPlayerHealthRechargeLimit(PlayerId(), original)
end

-- @local
function toss_drink(can)
    local ped = PlayerPedId()

    TaskPlayAnim(ped, DICTIONARY, ANIMATIONS[3], 8.0, 5.0, -1, 0, false, false, false)

    Citizen.Wait(750)

    if DoesEntityExist(can) then
        DetachEntity(can, true, true)
        DeleteEntity(can)
    end

    repeat
        Citizen.Wait(0)
    until cancelled or not IsEntityPlayingAnim(ped, DICTIONARY, ANIMATIONS[3], 3)
end
