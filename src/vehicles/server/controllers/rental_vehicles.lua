local function create(data)
    local player_id = source
    local cash      = exports.wallet:GetPlayerBalance(player_id)

    if cash >= data.price then
        exports.wallet:AdjustCash(player_id, -1 * data.price)
    else
        TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, {
            message = "You don't have enough cash.",
            flash   = true
        })
        return
    end

    local rental = RentalVehicle:new({
        player_id = player_id,
        model     = data.model,
        spawn     = data.location,
        renter    = data.name
    })

    rental:initialize()
end
RegisterNetEvent(Events.CREATE_RENTAL_VEHICLE, create)
