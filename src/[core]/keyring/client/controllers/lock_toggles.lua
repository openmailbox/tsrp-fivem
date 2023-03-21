local Animation = { DICTIONARY = "anim@mp_player_intmenu@key_fob@", NAME = "fob_click" }

local function update(data)
    if not NetworkDoesEntityExistWithNetworkId(data.entity) then return end

    if data.success then
        if not HasAnimDictLoaded(Animation.DICTIONARY) then
            RequestAnimDict(Animation.DICTIONARY)

            repeat
                Citizen.Wait(50)
            until HasAnimDictLoaded(Animation.DICTIONARY)
        end

        TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.NAME, 8.0, 8.0, -1, 48, 1, false, false, false)

        Logging.log(Logging.TRACE, "Toggled locks to " .. data.new_value .. " on " .. data.entity .. ".")
    else
        Logging.log(Logging.TRACE, "Failed key check for " .. data.entity .. ".")
    end
end
RegisterNetEvent(Events.UPDATE_KEYRING_LOCK_TOGGLE, update)
