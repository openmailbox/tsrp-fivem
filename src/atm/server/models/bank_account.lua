BankAccount = {}

function BankAccount.for_player(player_id)
end

function BankAccount:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function BankAccount:deposit(amount, cb)
end
