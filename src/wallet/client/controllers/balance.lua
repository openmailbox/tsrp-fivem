local WALLET_HASH = GetHashKey("MP0_WALLET_BALANCE")

local function update(data)
    StatSetInt(WALLET_HASH, data.balance, true)
end
RegisterNetEvent(Events.UPDATE_WALLET_BALANCE, update)
