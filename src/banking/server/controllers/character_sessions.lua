local function on_new_character(data)
    local character_id = data.character.id
    local player_id    = data.player_id

    BankAccount.for_character(character_id, function(baccount)
        TriggerClientEvent(Events.UPDATE_BANK_BALANCE, player_id, {
            new_balance = baccount.balance
        })
    end)
end
AddEventHandler(Events.ON_CHARACTER_SESSION_START, on_new_character)
