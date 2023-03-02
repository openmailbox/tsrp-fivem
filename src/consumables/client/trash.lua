Trash = {}

-- Forward declarations
local search_trash

local DICTIONARY     = "mini@repair"
local COOLDOWN_TIME  = 10000 -- ms
local FOOD_NAMES     = { "hamburger", "hot dog", "donut" }
local HEALTH_PER_BIN = 0.2
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

    return models
end

-- Blocks the thread it runs in.
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

    TurnToward(GetEntityCoords(object))

    TaskPlayAnim(PlayerPedId(), DICTIONARY, "fixing_a_ped", 8.0, 8.0, -1, 0, false, false, false)

    Citizen.Wait(SEARCH_TIME - (GetGameTimer() - start))

    Map.remove(object)
    ClearPedTasks(PlayerPedId())

    TriggerServerEvent(Events.CREATE_CONSUMABLES_REWARD)
end
