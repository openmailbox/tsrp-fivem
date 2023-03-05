local function create(data)
    local account_id = data.account.id
    local player_id  = data.account.player_id

    BankAccount.for_player_account(account_id, function(baccount)
        TriggerClientEvent(Events.UPDATE_BANK_BALANCE, player_id, {
            new_balance = baccount.balance
        })
    end)
end
AddEventHandler(Events.ON_ACCOUNT_LOADED, create)
