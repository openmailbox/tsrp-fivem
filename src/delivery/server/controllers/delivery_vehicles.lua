local function create(data)
    local player_id = source

    local vehicle = exports.vehicles:RentVehicle(player_id, {
        model    = data.model,
        location = data.location,
        name     = data.name
    })

    TriggerClientEvent(Events.UPDATE_DELIVERY_VEHICLE, player_id, {
        net_id = NetworkGetNetworkIdFromEntity(vehicle)
    })
end
RegisterNetEvent(Events.CREATE_DELIVERY_VEHICLE, create)

local function delete(data)
    local entity = NetworkGetEntityFromNetworkId(data.net_id)

    if entity then
        exports.vehicles:ReturnRental(entity)
    end
end
RegisterNetEvent(Events.DELETE_DELIVERY_VEHICLE, delete)
