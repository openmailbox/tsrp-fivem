local function update(data)
    StatSetInt(GetHashKey("BANK_BALANCE"), data.new_balance, true)
end
RegisterNetEvent(Events.UPDATE_BANK_BALANCE, update)
