local function update(data)
    print("update balance to " .. data.new_balance)
    StatSetInt(GetHashKey("BANK_BALANCE"), data.new_balance, true)
end
RegisterNetEvent(Events.UPDATE_BANK_BALANCE, update)
