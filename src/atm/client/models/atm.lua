Atm = {}

local INTERACT_NAME = 'Use ATM'

local MODELS = {
    GetHashKey('prop_atm_01'),
    GetHashKey('prop_atm_02'),
    GetHashKey('prop_atm_03'),
    GetHashKey('prop_fleeca_atm'),
}

function Atm.cleanup()
    for _, hash in ipairs(MODELS) do
        exports.interactions:UnregisterInteraction(hash, INTERACT_NAME)
    end
end

function Atm.initialize()
    for _, hash in ipairs(MODELS) do
        exports.interactions:RegisterInteraction({
            model  = hash,
            name   = INTERACT_NAME,
            prompt = "use the ATM"
        }, function(object)
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = Events.CREATE_ATM_SESSION
            })
        end)
    end
end
