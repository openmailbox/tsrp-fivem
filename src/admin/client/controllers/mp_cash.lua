local function update(data)
    StatSetInt(GetHashKey("MP0_WALLET_BALANCE"), data.amount, true)
end
RegisterNetEvent(Events.UPDATE_MP_CASH_BALANCE, update)
