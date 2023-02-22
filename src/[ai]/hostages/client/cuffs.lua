Cuffs = {}

local Animations = {
    Enter = { DICTIONARY = "mp_arrest_paired", NAME = "crook_p2_back_left" },
    Idle  = { DICTIONARY = "mp_arresting",     NAME = "idle" }
}

-- Controls to disable while player is cuffed.
local Controls = {
   SPRINT        = 21,   -- Shift/sprint,
   ENTER_VEHICLE = 23,   -- F/enter vehicle,
   ATTACK        = 24,   -- LMB/attack,
   AIM           = 25,   -- RMB/aim,
   RELOAD        = 45,   -- R/reload,
   EXIT_VEHICLE  = 75,   -- F/exit vehicle,
   MELEE_LIGHT   = 140,  -- R/light melee,
   MELEE_HEAVY   = 141,  -- Q/heavy melee,
   MELEE_ALT     = 142,  -- LMB/melee,
   WEAP_UNARMED  = 157,  -- 1/select unarmed,
   WEAP_MELEE    = 158,  -- 2/select melee,
   WEAP_HANDGUN  = 159,  -- 6/select melee,
   WEAP_SHOTGUN  = 160,  -- 3/select shotgun
   WEAP_SMG      = 161,  -- 7/select smg
   WEAP_RIFLE    = 162,  -- 8/select rifle
   WEAP_SNIPER   = 163,  -- 8/select sniper
   WEAP_HEAVY    = 164,  -- 4/select heavy
   WEAP_SPECIAL  = 165,  -- 5/select special
}

-- Forward declarations
local start_cuffed_player,
      start_updates

local is_active        = false
local is_player_cuffed = false
local cuffed           = {}

function Cuffs.cleanup()
    is_active = false

    for _, ped in ipairs(cuffed) do
        Cuffs.release(ped)
    end
end

function Cuffs.initialize(entity, lag)
    for _, ped in ipairs(cuffed) do
        if ped == entity then
            return false
        end
    end

    local time = GetGameTimer()

    Logging.log(Logging.DEBUG, "Cuffing " .. entity .. ".")

    if PlayerPedId() == entity and not is_player_cuffed then
        start_cuffed_player()
    end

    if not HasAnimDictLoaded(Animations.Enter.DICTIONARY) then
        RequestAnimDict(Animations.Enter.DICTIONARY)

        repeat
            Citizen.Wait(10)
        until HasAnimDictLoaded(Animations.Enter.DICTIONARY)
    end

    ClearPedTasksImmediately(entity)

    Citizen.Wait(math.max(10, GetGameTimer() - time + lag)) -- hacky anim sync
    TaskPlayAnim(entity, Animations.Enter.DICTIONARY, Animations.Enter.NAME, 3.0, -3.0, -1, 0, 0, 0, 0, 0)
    Citizen.Wait(GetAnimDuration(Animations.Enter.DICTIONARY, Animations.Enter.NAME) * 1000)

    SetCurrentPedWeapon(entity, Weapons.UNARMED, true)
    SetEnableHandcuffs(entity, true)

    table.insert(cuffed, entity)

    if not is_active then
        start_updates()
    end
end

function Cuffs.release(entity)
    Logging.log(Logging.DEBUG, "Uncuffing " .. entity .. ".")

    SetEnableHandcuffs(entity, false)
    SetPedCanPlayGestureAnims(entity, true)
    ClearPedTasks(entity)

    for i = #cuffed, 1, -1 do
        if cuffed[i] == entity then
            table.remove(cuffed, i)
            break
        end
    end

    if PlayerPedId() == entity then
        is_player_cuffed = false
    end
end

-- @local
function start_cuffed_player()
    Citizen.CreateThread(function()
        Logging.log(Logging.DEBUG, "Starting player cuff updates.")

        local jump_attempts = 0

        is_player_cuffed = true

        while is_player_cuffed do
            if IsPlayerDead(PlayerId()) or IsPedDeadOrDying(PlayerPedId(), 1) then
                break
            end

            for _, key in pairs(Controls) do
                DisableControlAction(0, key, true)
            end

            DisablePlayerFiring(PlayerId(), true)

            if IsControlJustPressed(0, 22) then -- spacebar/jump
                jump_attempts = jump_attempts + 1

                 if jump_attempts > 1 then
                    SetPedToRagdollWithFall(PlayerPedId(), 4000, 5000, 1, GetEntityForwardVector(PlayerPedId()), 1, 0, 0, 0, 0, 0, 0)

                    Citizen.SetTimeout(5000, function()
                        ClearPedTasks(PlayerPedId()) -- IsPlayerAnim() still thinks we're in the cuffed animation
                    end)

                    jump_attempts = 0
                end
            end

            Citizen.Wait(0)
        end

        is_player_cuffed = false

        Logging.log(Logging.DEBUG, "Stopping player cuff updates.")
    end)
end

-- @local
function start_updates()
    is_active = true

    if not HasAnimDictLoaded(Animations.Idle.DICTIONARY) then
        RequestAnimDict(Animations.Idle.DICTIONARY)

        repeat
            Citizen.Wait(20)
        until HasAnimDictLoaded(Animations.Idle.DICTIONARY)
    end

    Citizen.CreateThread(function()
        Logging.log(Logging.DEBUG, "Starting cuff updates.")

        while is_active do
            local ped

            for i = #cuffed, 1, -1 do
                ped = cuffed[i]

                if DoesEntityExist(ped) then
                    if not IsEntityPlayingAnim(ped, Animations.Idle.DICTIONARY, Animations.Idle.NAME, 3) then
                        TaskPlayAnim(ped, Animations.Idle.DICTIONARY, Animations.Idle.NAME, 3.0, -3.0, -1, 49, 0, 0, 0, 0)
                    end
                else
                    table.remove(cuffed, i)
                end
            end

            if #cuffed == 0 then
                break
            end

            Citizen.Wait(2000)
        end

        Logging.log(Logging.DEBUG, "Stopping cuff updates.")
        is_active = false
    end)
end
