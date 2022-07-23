local function create(data)
    local account_id = data.account.id
    local player_id  = data.account.player_id

    BankAccount.for_player_account(account_id, function(baccount)
        TriggerClientEvent(player_id, Events.UPDATE_BANK_BALANCE, {
            new_balance = baccount.balance
        })
    end)
end
AddEventHandler(Events.ON_ACCOUNT_LOADED, create)
