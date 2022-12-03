local function delete(data, cb)
    if data.success then
        VehicleDropoff.activate(Hayes.last_offer)
        Radar.activate(Hayes.last_offer)
    else
        Hayes.reset()
    end

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_CHOP_MISSION_OFFER, delete)

local function update(data)
    data.type  = Events.CREATE_CHOP_MISSION_OFFER
    data.name  = GetDisplayNameFromVehicleModel(data.model)
    data.label = GetLabelText(data.name)

    Hayes.last_offer = data

    Citizen.CreateThread(function()
        local buffer = data.ui_target - GetCloudTimeAsInt() - data.ping

        if buffer > 0 then
            Citizen.Wait(math.max(2000, buffer))
        end

        SetNuiFocus(true, true)
        SendNUIMessage(data)
    end)
end
RegisterNetEvent(Events.UPDATE_CHOP_MISSION_OFFER, update)
