Stash = {}

local INTERACT_NAME = "Open Stash"

local models = {}

function Stash.cleanup()
    for _, model in ipairs(models) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end
end

function Stash.initialize(data)
    models = data

    for _, model in ipairs(models) do
        exports.interactions:RegisterInteraction({
            model  = model,
            name   = INTERACT_NAME,
            prompt = "open the stash"
        }, function(object)
            exports.progress:ShowProgressBar(2000, "Opening")
            exports.interactions:AddExclusion(object)

            Citizen.Wait(1950)

            local hash       = GetHashKey("MP0_WALLET_BALANCE")
            local _, balance = StatGetInt(hash, -1)
            local new_b      = balance + 100

            StatSetInt(hash, new_b, true)
        end)
    end
end
