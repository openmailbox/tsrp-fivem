Trash = {}

-- Forward declarations
local notify,
      search_trash,
      turn_toward

local DICTIONARY     = "mini@repair"
local COOLDOWN_TIME  = 10000 -- ms
local FOOD_NAMES     = { "hamburger", "hot dog", "donut" }
local HEALTH_PER_BIN = 0.25
local INTERACT_NAME  = "Search for Food"
local SEARCH_TIME    = 3000 -- ms

function Trash.cleanup()
    for _, model in ipairs(Objects.DUMPSTERS) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end

    for _, model in ipairs(Objects.TRASH_BINS) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end
end

function Trash.initialize()
    local models = {}

    -- Objects defined in @common/shared/objects.lua
    for _, model in ipairs(Objects.DUMPSTERS) do
        table.insert(models, model)

        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = string.lower(INTERACT_NAME),
        }, search_trash)
    end

    for _, model in ipairs(Objects.TRASH_BINS) do
        table.insert(models, model)

        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = string.lower(INTERACT_NAME),
        }, search_trash)
    end

    return models
end

-- Runs inside a thread, hence in-line waits.
-- @local
function search_trash(object)
    local start = GetGameTimer()

    exports.interactions:AddExclusion(object)
    exports.progress:ShowProgressBar(SEARCH_TIME, "Searching")

    if not HasAnimDictLoaded(DICTIONARY) then
        RequestAnimDict(DICTIONARY)

        repeat
            Citizen.Wait(50)
        until HasAnimDictLoaded(DICTIONARY)
    end

    turn_toward(GetEntityCoords(object))

    TaskPlayAnim(PlayerPedId(), DICTIONARY, "fixing_a_ped", 8.0, 8.0, -1, 0, false, false, false)

    Citizen.Wait(SEARCH_TIME - (GetGameTimer() - start))

    Map.remove(object)
    ClearPedTasks(PlayerPedId())

    local original = GetPlayerHealthRechargeLimit(PlayerId())
    local target   = math.max(1.0, original + HEALTH_PER_BIN)

    notify("You found a discarded ~y~" .. FOOD_NAMES[math.random(1, #FOOD_NAMES)] .. "~s~.")
    SetPlayerHealthRechargeLimit(PlayerId(), target)

    Citizen.Wait(COOLDOWN_TIME)

    SetPlayerHealthRechargeLimit(PlayerId(), original)
end

-- @local
function notify(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

-- @local
function turn_toward(coords)
    local ped = PlayerPedId()

    TaskTurnPedToFaceCoord(ped, coords, -1)

    local v, w, angle, degrees
    repeat
        v       = GetEntityForwardVector(ped)
        w       = norm(coords - GetEntityCoords(ped))
        angle   = math.atan2((w.y * v.x) - (w.x * v.y), (w.x * v.x) + (w.y * v.y))
        degrees = angle * 180 / math.pi

        Citizen.Wait(100)
    until degrees > -20 and degrees < 20
end
