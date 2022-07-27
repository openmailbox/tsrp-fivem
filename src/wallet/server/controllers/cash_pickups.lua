-- Triggered by client when player picked up collectible cash object.
local function create(data)
    local player_id = source
    Wallet.adjust_cash(player_id, data.amount)
end
RegisterNetEvent(Events.CREATE_CASH_PICKUP, create)
