local function create(data)
    local player_id = source
    local paycheck  = math.random(50, 125)
    local character = exports.characters:GetPlayerCharacter(player_id)
    local name      = character.first_name .. " " .. character.last_name
    local reason    = "package delivery"

    if data.finished_route then
        paycheck = math.ceil(paycheck * 1.5)
        reason   = "finishing a delivery route"
    end

    Logging.log(Logging.INFO, "Paid $" .. paycheck .. " to " .. GetPlayerName(player_id) .. " (" .. player_id .. ") as " .. name .. " for " .. reason .. ".")

    exports.wallet:AdjustCash(player_id, paycheck)
end
RegisterNetEvent(Events.CREATE_DELIVERY_PACKAGE_DROPOFF, create)
