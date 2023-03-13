local function create(data)
    local player_id = source
    local character = exports.characters:GetPlayerCharacter(player_id)

    Logging.log(Logging.INFO, GetPlayerName(player_id) .. " (" .. player_id .. ") as " .. character.first_name .. " " .. character.last_name ..
                              " rented a " .. data.model .. " for $" .. data.price .. " at the " .. data.name .. ".")
end
RegisterNetEvent(Events.CREATE_RENTAL_VEHICLE, create)
