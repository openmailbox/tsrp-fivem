local function create(data)
    local player_id = source
    local balance   = exports.wallet:GetPlayerBalance(player_id)

    TriggerClientEvent(Events.UPDATE_FOOD_CHARGE_AUTH, player_id, {
        success = data.amount <= balance,
        amount  = data.amount
    })
end
RegisterNetEvent(Events.CREATE_FOOD_CHARGE_AUTH, create)

local function update(data)
    exports.wallet:AdjustCash(source, data.amount * -1)
end
RegisterNetEvent(Events.UPDATE_FOOD_CHARGE_AUTH, update)
