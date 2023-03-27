local pending = nil

local function create(data, cb)
    local impound = Impound.get_active()

    data.location = GetFirstAvailable(impound.spawns)

    pending = cb
    TriggerServerEvent(Events.CREATE_PARKED_VEHICLE_RETRIEVAL, data)
end
RegisterNUICallback(Events.CREATE_PARKED_VEHICLE_RETRIEVAL, create)

local function update(data)
    if data.success then
        local impound = Impound.get_active()

        Impound.set_active(nil)

        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, { message = "Your ~g~vehicle~s~ is ready." })

        Citizen.SetTimeout(5000, function()
            impound:initialize()
        end)
    end

    pending(data)
    pending = nil
end
RegisterNetEvent(Events.UPDATE_PARKED_VEHICLE_RETRIEVAL, update)
