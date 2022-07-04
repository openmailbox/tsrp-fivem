Account = {}

-- Forward declarations
local load_account,
      save_new_account,
      sync_identifiers

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
            id    = nil, -- this will get populated if/when the identifier exists in the DB
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

    load_account(account, function(a)
        cb(a)

        -- This can happen async in the background while connection handshake continues.
        sync_identifiers(a)
    end)
end

function Account:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Account:set_player_id(new_id)
    accounts[self.player_id] = nil
    self.player_id = tonumber(new_id)
    accounts[self.player_id] = self
end

function Account:unload()
    accounts[self.player_id] = nil
end

-- @local
function load_account(account, cb)
    local without_ip = {}

    -- We exclude account lookups by IP b/c multiple players might connect from the same IP.
    for _, ident in ipairs(account.identifiers) do
        if not string.match(ident.value, "^ip:") then
            table.insert(without_ip, ident.value)
        end
    end

    MySQL.Async.fetchScalar(
        [[SELECT id FROM accounts
          INNER JOIN identifiers ON identifiers.account_id = accounts.id
          WHERE identifiers.value IN (']] .. table.concat(without_ip, "', '") .. [[')
          LIMIT 1;]],
        {},
        function(id)
            if id then
                account.id = id

                MySQL.Async.execute(
                    "UPDATE accounts SET last_connect_at = NOW() WHERE id = @id",
                    { ["@id"] = account.id },
                    function(_)
                        cb(account)
                    end
                )
            else
                save_new_account(account, cb)
            end
        end
    )
end

-- @local
function save_new_account(account, cb)
    MySQL.Async.insert(
        "INSERT INTO accounts (created_at, last_connect_at, name) VALUES (NOW(), NOW(), @name);",
        { ["@name"] = account.name },
        function(new_id)
            account.id = new_id
            cb(account)
        end
    )
end

-- Makes sure any identifiers associated with the player are saved so that we can use them
-- to ID the player in the future.
-- @local
function sync_identifiers(account)
    MySQL.Async.fetchAll(
        "SELECT * FROM identifiers WHERE account_id = @id",
        { ["@id"] = account.id },
        function(results)
            local missing = {}

            -- Populate the `id` field in the account identifiers from any that we already knew about in the DB
            for _, row in ipairs(results) do
                for _, ident in ipairs(account.identifiers) do
                    if ident.value == row.value then
                        ident.id = row.id
                        break
                    end
                end
            end

            -- Those that still do not have an `id` are new/unsaved.
            for _, ident in ipairs(account.identifiers) do
                if not ident.id then
                    table.insert(missing, ident.value)
                end
            end

            for _, value in ipairs(missing) do
                MySQL.Async.insert(
                    "INSERT INTO identifiers (account_id, value) VALUES (@id, @value)",
                    {
                        ["@id"]    = account.id,
                        ["@value"] = value
                    },
                    function(new_id)
                        for _, ident in ipairs(account.identifiers) do
                            if ident.value == value then
                                ident.id = new_id
                                break
                            end
                        end
                    end
                )
            end
        end
    )
end
