local function create(data)
    local player_id = source
    local cash      = exports.wallet:GetPlayerBalance(player_id)

    if cash >= data.price then
        exports.wallet:AdjustCash(player_id, -1 * data.price)
        PlayerVehicle.rent(player_id, data)
        TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = "Your ~b~vehicle~s~ is ready." })
    else
        exports.banking:Withdraw(player_id, data.price, function(_, err)
            if err then
                TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = err })
            else
                PlayerVehicle.rent(player_id, data)
                TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = "Your ~b~vehicle~s~ is ready." })
            end
        end)
    end
end
RegisterNetEvent(Events.CREATE_RENTAL_VEHICLE, create)
