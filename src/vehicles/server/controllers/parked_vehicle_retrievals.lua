local function create(data)
    local player_id = source
    local character = exports.characters:GetPlayerCharacter(player_id)

    Vehicle.from_id(data.id, function(record)
        local vehicle = PlayerVehicle:new({
            id        = record.id,
            player_id = player_id,
            model     = record.model,
            spawn     = data.location,
            plate     = record.plate
        })

        vehicle:initialize()

        TriggerClientEvent(Events.UPDATE_PARKED_VEHICLE_RETRIEVAL, player_id, {
            success = true
        })

        Vehicle.touch(record.id)

        Logging.log(Logging.INFO, GetPlayerName(player_id) .. " (" .. player_id .. ") as " .. character.first_name .. " " .. character.last_name ..
                                  " retrieved their " .. vehicle.model .. " (" .. vehicle.plate .. ") from parking.")
    end)
end
RegisterNetEvent(Events.CREATE_PARKED_VEHICLE_RETRIEVAL, create)
