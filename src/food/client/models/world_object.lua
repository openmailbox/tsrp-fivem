WorldObject = {}

-- Forward declarations
local notify

local COOLDOWN_TIME   = 10000 -- ms
local FOOD_NAMES      = { "hamburger", "hot dog", "donut" }
local HEALTH_PER_ITEM = 0.25
local INTERACT_NAME   = "Search for Food"
local SEARCH_TIME     = 3000 -- ms

local models = {}

-- Objects defined in @common/shared/objects.lua
for _, model in ipairs(Objects.DUMPSTERS) do
    table.insert(models, model)
end

for _, model in ipairs(Objects.TRASH_BINS) do
    table.insert(models, model)
end

function WorldObject.activate()
    for _, model in ipairs(models) do
        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = "search for food"
        }, function(object)
            exports.interactions:AddExclusion(object)
            exports.progress:ShowProgressBar(SEARCH_TIME, "Searching")

            Citizen.Wait(SEARCH_TIME)

            local original = GetPlayerHealthRechargeLimit(PlayerId())
            local target   = math.max(1.0, original + HEALTH_PER_ITEM)

            notify("You found a discarded ~y~" .. FOOD_NAMES[math.random(1, #FOOD_NAMES)] .. "~s~.")
            SetPlayerHealthRechargeLimit(PlayerId(), target)

            Citizen.Wait(COOLDOWN_TIME)

            SetPlayerHealthRechargeLimit(PlayerId(), original)
        end)
    end
end

function WorldObject.deactivate()
    for _, model in ipairs(models) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end
end

-- @local
function notify(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end
