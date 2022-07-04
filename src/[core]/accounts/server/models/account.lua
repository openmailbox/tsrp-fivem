Account = {}

local accounts = {}

function Account.ban(id, days)
    Account.find_by_id(id, function(account)
        if not account then return end
        account:ban(days)
    end)
end
exports("BanAccount", Account.ban)

function Account.unban(id)
    Account.find_by_id(id, function(account)
        if not account then return end
        account:unban()
    end)
end
exports("UnbanAccount", Account.unban)

function Account.find_by_id(id, cb)
    MySQL.Async.fetchAll(
        "SELECT * FROM accounts WHERE id = @id",
        { ["@id"] = id },
        function(results)
            if #results == 0 then
                cb(nil)
            end

            local account = Account:new(nil, results[1].name)

            for k, v in pairs(results[1]) do
                account[k] = v
            end

            cb(account)
        end
    )
end

--- Look up an account by license identifier.
-- @tparam string identifier an account identifier in the format of 'steam:12345'
-- @tparam function cb a callback that will receive the located account or nil
function Account.find_by_identifier(identifier, cb)
    MySQL.Async.fetchAll(
        [[SELECT accounts.id AS id, accounts.created_at AS created_at, last_connected, whitelisted, name,
                 banned_until, priority FROM accounts
        INNER JOIN identifiers ON identifiers.account_id = accounts.id
        WHERE identifiers.value = @identifier]],
        { ["@identifier"] = identifier },
        function(results)
            local found = {}

            for _, data in ipairs(results) do
                local account = Account:new(nil, data.name)

                for k, v in pairs(data) do
                    account[k] = v
                end

                table.insert(found, account)
            end

            cb(found)
        end
    )
end
exports("GetIdentifierAccount", Account.find_by_identifier)

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
    return accounts[tonumber(player_id)]
end
exports("GetPlayerAccount", Account.for_player)


function Account:new(player_id, name)
    local o = {}

    o.player_id   = tonumber(player_id)
    o.name        = name
    o.is_loading  = false
    o.priority    = 0
    o.whitelisted = false
    o.identifiers = o.identifiers or {}

    setmetatable(o, self)
    self.__index = self

    if o.player_id ~= nil then
        accounts[o.player_id] = o
    end

    return o
end

--- Ban this account for a specified number of days
-- @tparam number days the number of days the ban should be in place
function Account:ban(days)
    MySQL.Async.execute(
        "UPDATE accounts SET banned_until = DATE_ADD(NOW(), INTERVAL @days DAY)",
        { ["@days"] = days },
        function(rows_changed)
            if rows_changed == 0 then
                Citizen.Trace("WARNING: Unknown error when applying " .. days .. "-day ban to account " ..
                              self.id .. "\n")
            end
        end
    )
end

function Account:ban_time_remaining()
    if not self.banned_until then return end

    local seconds = math.floor(os.difftime(os.time(self.banned_until), os.time()))

    if seconds < 0 then return end

    return exports.utility:DisplayDuration(seconds)
end

function Account:reload(cb)
    if self.is_loading then return end

    self.is_loading  = true
    self.identifiers = {}

    local identifiers = GetPlayerIdentifiers(self.player_id)
    local without_ip  = {}
    local params      = {}
    local query       = [[SELECT * FROM accounts
                        INNER JOIN identifiers ON identifiers.account_id = accounts.id
                        WHERE identifiers.value IN (]]

    for i in ipairs(identifiers) do
        table.insert(self.identifiers, {value = identifiers[i]})

        if not string.match(identifiers[i], "^ip:") then
            table.insert(without_ip, identifiers[i])
        end
    end

    if (#identifiers == 0) then
        if cb then
            cb(self)
        end

        return
    end

    Citizen.Trace("Reloading account data for Player " .. self.player_id .. "\n")

    MySQL.Async.fetchAll(
        query .. '"' .. table.concat(without_ip, '", "') .. '")',
        params,
        function (results)
            if #results == 0 then
                self:save()
            else
                self.id          = results[1].account_id
                self.whitelisted = results[1].whitelisted
                self.priority    = results[1].priority

                if results[1].banned_until and results[1].banned_until > 0 then
                    self.banned_until = os.date("*t", results[1].banned_until / 1000)
                end

                for i in ipairs(results) do
                    for j in ipairs(self.identifiers) do
                        if self.identifiers[j].value == results[i].value then
                            for k, v in pairs(results[i]) do
                                self.identifiers[j][k] = v
                            end
                            break
                        end
                    end
                end

                print("Loaded account " .. self.id .. " for Player " .. self.player_id)

                MySQL.Async.execute("UPDATE accounts SET last_connected = NOW() WHERE id = @id", {["@id"] = self.id})

                self:save() -- Save any missing identifiers
            end

            self.is_loading = false

            if cb then
                cb(self)
            end
        end
    )
end

function Account:save()
    if self.id == nil then
        local ip = nil

        for _, ident in ipairs(self.identifiers or {}) do
            local match = string.match(ident.value, "^ip:(.+)")

            if match then
                ip = ident
                break
            end
        end

        if ip then
            TriggerEvent(
                Events.CREATE_DISCORD_LOG,
                "Creating new account for '" .. tostring(self.name) .. "' from " .. tostring(ip.value)
            )
        end

        MySQL.Async.fetchAll(
            [[INSERT INTO accounts (created_at, last_connected, name) VALUES (NOW(), NOW(), @name);
              SELECT LAST_INSERT_ID();]],
            { ["@name"] = self.name },
            function(results)
                if results[1].id == 0 then
                    print("MySQL error while creating account for Player " .. self.player_id)
                else
                    self.id = results[1].insertId
                    self:save_identifiers(self)
                end
            end
        )
    else
        self:save_identifiers()
    end
end

function Account:save_identifiers()
    local query   = "INSERT INTO identifiers (account_id, created_at, value) VALUES "
    local params  = {["@accountID"] = self.id}
    local missing = 0

    for i in ipairs(self.identifiers) do
        if self.identifiers[i].id == nil then
            missing = missing + 1

            if missing > 1 then
                query = query .. ", "
            end

            query = query .. "(@accountID, NOW(), @v" .. i .. ")"
            params["@v" .. i] = self.identifiers[i].value
        end
    end

    if missing > 0 then
        query = query .. " ON DUPLICATE KEY UPDATE account_id = @accountID"
        MySQL.Async.execute(query, params)
    end
end

function Account:set_player_id(new_id)
    accounts[self.player_id] = nil
    self.player_id = tonumber(new_id)
    accounts[self.player_id] = self
end

function Account:unban()
    if not self.id then return end

    MySQL.Async.execute(
        "UPDATE accounts SET banned_until = NULL WHERE id = @id",
        { ["@id"] = self.id },
        function(rows_changed)
            if rows_changed == 0 then
                Citizen.Trace("WARNING: Unknown error when unbanning account #" .. self.id .. "\n")
            end
        end
    )
end

function Account:unload()
    accounts[self.player_id] = nil
end

function Account:update_whitelist(status)
    if self.whitelisted == status then return end

    self.whitelisted = status

    MySQL.Async.execute(
        [[UPDATE accounts SET
        whitelisted = @whitelisted
        WHERE id = @id]],
        {
            ["@whitelisted"] = self.whitelisted,
            ["@id"]          = self.id
        }
    )
end
