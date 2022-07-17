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
        exports.progress:ShowProgressBar(2000, "Opening")
        exports.interactions:AddExclusion(object)

        Citizen.Wait(1950)

        local hash       = GetHashKey("MP0_WALLET_BALANCE")
        local _, balance = StatGetInt(hash, -1)
        local new_b      = balance + 100

        StatSetInt(hash, new_b, true)
        exports.interactions:RemoveExclusion(object)
    end)
end
