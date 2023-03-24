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

    Exports.deposit(player_id, data.amount, function(new_balance, err)
        if err then
            Logging.log("Unable to complete ATM deposit for " .. GetPlayerName(player_id) .. " (" .. player_id .. "): " .. err .. ".")
        else
            exports.wallet:AdjustCash(player_id, -1 * data.amount)
        end

        TriggerClientEvent(Events.UPDATE_ATM_DEPOSIT, player_id, {
            success     = not err,
            amount      = data.amount,
            new_balance = new_balance
        })
    end)
end
RegisterNetEvent(Events.CREATE_ATM_DEPOSIT, create)
