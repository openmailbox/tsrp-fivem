Wallet = {}

local wallets = {} -- All wallets for connected players

-- @treturn number the new balance post-adjustment.
function Wallet.adjust_cash(player_id, amount)
    if amount == 0 then return true end

    local wallet      = Wallet.for_player(player_id)
    local new_balance = math.max(wallet.balance + amount, 0)

    wallet.balance = new_balance

    TriggerClientEvent(Events.UPDATE_WALLET_BALANCE, player_id, {
        balance = new_balance
    })

    return new_balance
end
exports("AdjustCash", Wallet.adjust_cash)

function Wallet.for_player(player_id)
    local wallet = wallets[player_id]

    if not wallet then
        wallet = Wallet:new({ balance = 0 })
        wallets[player_id] = wallet
    end

    return wallet
end

function Wallet.get_balance(player_id)
    local wallet = wallets[player_id]
    return (wallet and wallet.balance) or 0
end
exports("GetPlayerBalance", Wallet.get_balance)

function Wallet:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end
