local function create()
    local player_id = source

    exports.wallet:AdjustCash(player_id, 5000)

    TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, {
        message = "Money's on the way. Stop by for more work.",
        sender  = {
            image   = "CHAR_MAUDE",
            name    = "Maude",
            subject = "Job Complete"
        }
    })
end
RegisterNetEvent(Events.CREATE_BOUNTY_PAYOUT, create)
