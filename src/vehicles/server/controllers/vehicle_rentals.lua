-- Forward declarations
local init_vehicle

local function create(data)
    local player_id = source
    local cash      = exports.wallet:GetPlayerBalance(player_id)

    if cash >= data.price then
        exports.wallet:AdjustCash(player_id, -1 * data.price)
        init_vehicle(player_id, data)
    else
        exports.banking:Withdraw(player_id, data.price, function(_, err)
            if err then
                TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = err })
            else
                init_vehicle(player_id, data)

                TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, { message = "Your ~b~vehicle~s~ is ready." })
            end
        end)
    end
end
RegisterNetEvent(Events.CREATE_RENTAL_VEHICLE, create)

-- @local
function init_vehicle(player_id, data)
    local rental = PlayerVehicle:new({
        player_id = player_id,
        model     = data.model,
        spawn     = data.location,
        renter    = data.name
    })

    rental:initialize()

    local character = exports.characters:GetPlayerCharacter(player_id)

    Logging.log(Logging.INFO, GetPlayerName(player_id) .. " (" .. player_id .. ") as " .. character.first_name .. " " .. character.last_name ..
                              " rented a " .. data.model .. " for $" .. tostring(data.price or 0) .. " at the " .. data.name .. ".")
end
