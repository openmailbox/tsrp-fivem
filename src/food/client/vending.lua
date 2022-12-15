Vending = {}

-- Forward declarations
local buy_soda,
      load_model,
      release_resources

local ANIMATIONS    = { "plyr_buy_drink_pt1", "plyr_buy_drink_pt2", "plyr_buy_drink_pt3" }
local DICTIONARY    = "mini@sprunk"
local INTERACT_NAME = "Pay $2 for Soda"

local models = {}

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
        }, buy_soda)
    end

    return models
end

-- Blocks the thread it runs in.
-- @local
function buy_soda(object)
    exports.interactions:AddExclusion(object)

    local ped      = PlayerPedId()
    local position = GetOffsetFromEntityInWorldCoords(object, 0.0, -0.97, 0.05)
    local model    = GetHashKey("prop_ecola_can")

    LoadAnimDictionary(DICTIONARY)
    RequestAmbientAudioBank("VENDING_MACHINE")
    HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
    load_model(model)

    --TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
    --    message = "Press ~INPUT_VEH_DUCK~ to cancel."
    --})

    local cancelled = false

    Citizen.CreateThread(function()
        while not cancelled do
            DisplayHelpTextThisFrame("Press ~INPUT_VEH_DUCK~ to cancel.", 0)

            if IsControlJustPressed(0, 73) then
                cancelled = true
            end

            Citizen.Wait(0)
        end
    end)

    if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
        TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(object), 0.1)

        while not cancelled and not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) do
            Citizen.Wait(50)
        end
    end

    if cancelled then
        release_resources(object, model)
        return
    end

    TurnToward(GetEntityCoords(object))

    local progress = exports.progress:ShowProgressBar(11500, "Buying Drink")

    SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
    SetPedResetFlag(ped, 322, true)
    TaskPlayAnim(ped, DICTIONARY, ANIMATIONS[1], 8.0, 5.0, -1, 0, false, false, false)

    local timeout = GetGameTimer() + 2500
    while not cancelled and GetGameTimer() < timeout do
        Citizen.Wait(50)
    end

    if cancelled then
        release_resources(object, model)
        return
    end

    local can = CreateObjectNoOffset(model, position, true, false, false)
    SetEntityAsMissionEntity(can, true, true)
    SetEntityProofs(can, false, true, false, false, false, false, 0, false)
    AttachEntityToEntity(can, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

    repeat
        Citizen.Wait(0)
    until cancelled or not IsEntityPlayingAnim(ped, DICTIONARY, ANIMATIONS[1], 3)

    if cancelled then
        exports.progress:CancelProgressBar(progress)
        release_resources(object, model, can)
        return
    end

    TaskPlayAnim(ped, DICTIONARY, ANIMATIONS[2], 8.0, 5.0, -1, 0, false, false, false)

    repeat
        Citizen.Wait(0)
    until cancelled or not IsEntityPlayingAnim(ped, DICTIONARY, ANIMATIONS[2], 3)

    if cancelled then
        exports.progress:CancelProgressBar(progress)
        release_resources(object, model, can)
        return
    end

    TaskPlayAnim(ped, DICTIONARY, ANIMATIONS[3], 8.0, 5.0, -1, 0, false, false, false)

    Citizen.Wait(750)

    if DoesEntityExist(can) then
        DetachEntity(can, true, true)
        DeleteEntity(can)
    end

    repeat
        Citizen.Wait(0)
    until cancelled or not IsEntityPlayingAnim(ped, DICTIONARY, ANIMATIONS[3], 3)

    release_resources(object, model, can)

    cancelled = false

    exports.progress:CancelProgressBar(progress)

    local original = GetPlayerHealthRechargeLimit(PlayerId())
    local target   = math.max(1.0, original + 0.5)

    SetPlayerHealthRechargeLimit(PlayerId(), target)

    Citizen.Wait(10000)

    SetPlayerHealthRechargeLimit(PlayerId(), original)
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
function release_resources(object, model, can)
    if can and DoesEntityExist(can) then
        DetachEntity(can, true, true)
        DeleteEntity(can)
    end

    ClearPedTasks(PlayerPedId())
    SetModelAsNoLongerNeeded(model)
    ReleaseAmbientAudioBank()
    RemoveAnimDict(DICTIONARY)

    exports.interactions:RemoveExclusion(object)
end