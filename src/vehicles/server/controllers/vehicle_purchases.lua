local function create(data)
    local player_id = source

    exports.banking:Withdraw(player_id, data.price, function(_, err)
        if err then
            TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = err })
            return
        end

        local vehicle = PlayerVehicle:new({
            player_id = player_id,
            model     = data.model,
            spawn     = data.location
        })

        vehicle:initialize()
        vehicle:save()

        TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = "Your ~g~vehicle~s~ is ready." })

        local character = exports.characters:GetPlayerCharacter(player_id)

        Logging.log(Logging.INFO, GetPlayerName(player_id) .. " (" .. player_id .. ") as " .. character.first_name .. " " .. character.last_name ..
                                  " purchased a " .. data.model .. " for $" .. tostring(data.price or 0) .. " at " .. data.dealer .. ".")
    end)
end
RegisterNetEvent(Events.CREATE_VEHICLE_PURCHASE, create)
