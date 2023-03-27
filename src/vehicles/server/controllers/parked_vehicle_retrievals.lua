local function create(data)
    local player_id = source

    Vehicle.from_id(data.id, function(record)
        local vehicle = PlayerVehicle:new({
            id        = record.id,
            player_id = player_id,
            model     = record.model,
            spawn     = data.location
        })

        vehicle:initialize()

        TriggerClientEvent(Events.UPDATE_PARKED_VEHICLE_RETRIEVAL, player_id, {
            success = true;
        })
    end)
end
RegisterNetEvent(Events.CREATE_PARKED_VEHICLE_RETRIEVAL, create)
