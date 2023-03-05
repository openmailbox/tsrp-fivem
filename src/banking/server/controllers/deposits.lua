local function create(data)
    local player_id = source

    if data.amount < 1 then
        TriggerClientEvent(Events.UPDATE_ATM_DEPOSIT, player_id, {
            success = false,
            error   = "Deposit must be greater than $0."
        })
        return
    end

    local wallet = exports.wallet:GetPlayerBalance(player_id)

    if wallet < data.amount then
        TriggerClientEvent(Events.UPDATE_ATM_DEPOSIT, player_id, {
            success = false,
            error   = "Insufficient cash in your wallet."
        })
        return
    end

    BankAccount.for_player(player_id, function(account)
        exports.wallet:AdjustCash(player_id, -1 * data.amount)

        account:deposit(data.amount)

        TriggerClientEvent(Events.UPDATE_ATM_DEPOSIT, player_id, {
            success     = true,
            amount      = data.amount,
            new_balance = account.balance
        })
    end)
end
RegisterNetEvent(Events.CREATE_ATM_DEPOSIT, create)
