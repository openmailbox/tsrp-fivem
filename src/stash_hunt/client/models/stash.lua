Stash = {}

local INTERACT_NAME = "Open"
local MODEL         = GetHashKey('prop_mil_crate_01')

function Stash.cleanup()
    exports.interactions:UnregisterInteraction(MODEL, INTERACT_NAME)
end

function Stash.initialize()
    exports.interactions:RegisterInteraction({
        model  = MODEL,
        name   = INTERACT_NAME,
        prompt = "open the crate"
    }, function(object)
        print("TODO: Generate loot.")
    end)
end
