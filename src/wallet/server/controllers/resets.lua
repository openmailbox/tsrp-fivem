-- Triggered by playerSpawned event.
local function create()
    local player_id = source
    local wallet    = Wallet.for_player(player_id)

    wallet.balance = 0

    TriggerClientEvent(Events.UPDATE_WALLET_BALANCE, player_id, {
        balance = wallet.balance
    })
end
RegisterNetEvent(Events.CREATE_WALLET_RESET, create)
