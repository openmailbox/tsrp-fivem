local function delete(data, cb)
    if data.success then
    else
        Maudes.reset()
    end

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_BOUNTY_MISSION_OFFER, delete)

local function update(data)
    data.type = Events.CREATE_BOUNTY_MISSION_OFFER

    Citizen.CreateThread(function()
        local buffer = data.ui_target - GetCloudTimeAsInt() - data.ping

        if buffer > 0 then
            Citizen.Wait(math.max(2000, buffer))
        end

        SetNuiFocus(true, true)
        SendNUIMessage(data)
    end)
end
RegisterNetEvent(Events.UPDATE_BOUNTY_MISSION_OFFER, update)
