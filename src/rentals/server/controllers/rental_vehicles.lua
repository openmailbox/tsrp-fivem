local function create(data)
    local player_id = source

    local rental = RentalVehicle:new({
        player_id = player_id,
        model     = data.model,
        spawn     = data.location,
        renter    = data.name
    })

    rental:initialize()
end
RegisterNetEvent(Events.CREATE_RENTAL_VEHICLE, create)
