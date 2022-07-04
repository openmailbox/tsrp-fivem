Account = {}

-- Contains in-memory accounts for all connected players.
local accounts = {}

function Account.for_identifier(identifier)
    for _, account in pairs(accounts) do
        for i in ipairs(account.identifiers) do
            if account.identifiers[i].value == identifier then
                return account
            end
        end
    end

    return nil
end

function Account.for_player(player_id)
    return accounts[player_id]
end
exports("GetPlayerAccount", Account.for_player)

function Account.initialize(player_id, name, cb)
    local identifiers = {}

    for _, ident in ipairs(GetPlayerIdentifiers(player_id)) do
        table.insert(identifiers, {
            id    = nil, -- this will get populated if the identifier exists in the DB
            value = ident
        })
    end

    local account = Account:new({
        player_id   = player_id,
        name        = name,
        identifiers = identifiers,
        priority    = 0
    })

    accounts[player_id] = account

    account:reload(cb)
end

function Account:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Account:reload(cb)
    -- TODO: Use identifiers to find or create an account in the db
    cb(self)
end

function Account:set_player_id(new_id)
    accounts[self.player_id] = nil
    self.player_id = tonumber(new_id)
    accounts[self.player_id] = self
end

function Account:unload()
    accounts[self.player_id] = nil
end
