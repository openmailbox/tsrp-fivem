Atm = {}

local INTERACT_NAME = 'Use ATM'

local MODELS = {
    GetHashKey('prop_atm_01'),
    GetHashKey('prop_atm_02'),
    GetHashKey('prop_atm_03'),
    GetHashKey('prop_fleeca_atm'),
}

local is_showing = false

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
        }, function(_)
            if tonumber(GetPlayerWantedLevel(PlayerId())) > 0 or tonumber(GetPlayerFakeWantedLevel(PlayerId())) > 0 then
                TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
                    message = "You can't do that right now."
                })
                return
            end

            SetNuiFocus(true, true)

            local _, cash = StatGetInt(GetHashKey("MP0_WALLET_BALANCE"), -1)

            SendNUIMessage({
                type = Events.CREATE_ATM_SESSION,
                cash = cash
            })

            is_showing = true

            Citizen.CreateThread(function()
                while is_showing do
                    ShowHudComponentThisFrame(3)
                    ShowHudComponentThisFrame(4)
                    Citizen.Wait(10)
                end
            end)
        end)
    end
end

function Atm.stop_showing()
    SetNuiFocus(false, false)
    is_showing = false;
end
