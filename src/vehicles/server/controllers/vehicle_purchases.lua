local function create(data)
    local player_id = source

    exports.banking:Withdraw(player_id, data.price, function(_, err)
        TriggerClientEvent(Events.UPDATE_VEHICLE_PURCHASE, player_id, {
            error    = err,
            location = data.location,
            model    = data.model
        })
    end)
end
RegisterNetEvent(Events.CREATE_VEHICLE_PURCHASE, create)
