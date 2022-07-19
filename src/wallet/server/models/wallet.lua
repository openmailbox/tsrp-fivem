Wallet = {}

local wallets = {} -- All wallets for connected players

function Wallet.adjust_cash(player_id, amount)
    if amount == 0 then return true end

    local wallet      = Wallet.for_player(player_id)
    local new_balance = wallet.balance + amount

    if new_balance < 0 then
        return false
    end

    wallet.balance = new_balance

    TriggerClientEvent(Events.UPDATE_WALLET_BALANCE, player_id, {
        balance = new_balance
    })

    return true
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

function Wallet:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end
