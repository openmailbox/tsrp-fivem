local DEFAULT_PAYOUT = 5000

local function create(data)
    local player_id = source
    local amount    = DEFAULT_PAYOUT
    local message   = "Nice job. Stop by for more work."

    if data.target_dead then
        amount  = math.ceil(amount * 0.5)
        message = "You only get half for a corpse. I need them alive, asshole."
    end

    exports.wallet:AdjustCash(player_id, amount)

    TriggerClientEvent(Events.CREATE_HUD_NOTIFICATION, player_id, {
        message = message,
        sender  = {
            image   = "CHAR_MAUDE",
            name    = "Maude",
            subject = "Job Complete"
        }
    })
end
RegisterNetEvent(Events.CREATE_BOUNTY_PAYOUT, create)
