local function update(data)
    local vehicle = NetToVeh(data.net_id)
    local rental  = RentalVehicle:new({ entity = vehicle })

    rental:initialize()
end
RegisterNetEvent(Events.UPDATE_RENTAL_VEHICLE, update)
