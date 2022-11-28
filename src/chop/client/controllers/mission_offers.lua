local function delete(data, cb)
    SetNuiFocus(false, false)
    cb({})

    if data.success then
        VehicleDropoff.activate(Hayes.last_offer)
    else
        Hayes.reset()
    end
end
RegisterNUICallback(Events.DELETE_CHOP_MISSION_OFFER, delete)

local function update(data)
    data.type  = Events.CREATE_CHOP_MISSION_OFFER
    data.name  = GetDisplayNameFromVehicleModel(data.model)
    data.label = GetLabelText(data.name)

    Hayes.last_offer = data
    SendNUIMessage(data)

    SetNuiFocus(true, true)
end
RegisterNetEvent(Events.UPDATE_CHOP_MISSION_OFFER, update)
