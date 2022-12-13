Trash = {}

-- Forward declarations
local notify,
      search_trash

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
    -- Objects defined in @common/shared/objects.lua
    for _, model in ipairs(Objects.DUMPSTERS) do
        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = string.lower(INTERACT_NAME),
        }, search_trash)
    end

    for _, model in ipairs(Objects.TRASH_BINS) do
        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = string.lower(INTERACT_NAME),
        }, search_trash)
    end
end

-- @local
function search_trash(object)
    exports.interactions:AddExclusion(object)
    exports.progress:ShowProgressBar(SEARCH_TIME, "Searching")

    Citizen.Wait(SEARCH_TIME)

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