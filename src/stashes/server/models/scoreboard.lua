Scoreboard = {}

local AWARD_AMOUNT = 1000
local MAX_SCORE    = 20

-- In-memory Player->ScoreCollection map of active scores for all connected players.
local all_scores = {}

-- Adjust a player's score for a given label by specified amount.
-- @tparam number player_id
-- @tparam string label
-- @tparam number amount
-- @treturn number the player's new score for the label
function Scoreboard.record(player_id, label, amount)
    local scores = all_scores[player_id]

    if not scores then
        scores = {}
        all_scores[player_id] = scores
    end

    if not scores[label] then
        scores[label] = 0
    end

    scores[label] = scores[label] + amount

    if scores[label] == MAX_SCORE then
        TriggerClientEvent(Events.ADD_CHAT_MESSAGE, player_id, {
            color     = Colors.GREEN,
            multiline = true,
            args      = { "BONUS", "You earned ^2^*$" .. AWARD_AMOUNT .. "^r^7 for getting " .. MAX_SCORE .. " kills with " .. label .. "." }
        })

        exports.wallet:AdjustCash(player_id, AWARD_AMOUNT)
    end

    return scores[label]
end

function Scoreboard.unregister(player_id)
    all_scores[player_id] = nil
end
