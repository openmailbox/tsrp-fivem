WorldObject = {}

-- Forward declarations
local notify

local COOLDOWN_TIME   = 10000 -- ms
local FOOD_NAMES      = { "hamburger", "hot dog", "donut" }
local HEALTH_PER_ITEM = 0.25
local INTERACT_NAME   = "Search for Food"
local SEARCH_TIME     = 3000 -- ms

local MODELS = {
     GetHashKey("prop_cs_dumpster_01a"),
     GetHashKey("p_dumpster_t"),
     GetHashKey("prop_snow_dumpster_01"),
     GetHashKey("prop_dumpster_01a"),
     GetHashKey("prop_dumpster_02a"),
     GetHashKey("prop_dumpster_02b"),
     GetHashKey("prop_dumpster_3a"),
     GetHashKey("prop_dumpster_4a"),
     GetHashKey("prop_dumpster_4b"),
}

function WorldObject.activate()
    for _, model in ipairs(MODELS) do
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
    for _, model in ipairs(MODELS) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end
end

-- @local
function notify(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end
