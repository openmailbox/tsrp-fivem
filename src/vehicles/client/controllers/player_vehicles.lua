local function update(data)
    local entity  = NetToVeh(data.net_id)
    local vehicle = PlayerVehicle:new(data.vehicle)

    vehicle.entity = entity

    vehicle:initialize()
end
RegisterNetEvent(Events.UPDATE_PLAYER_VEHICLES, update)
