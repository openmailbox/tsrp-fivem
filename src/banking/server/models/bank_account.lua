BankAccount = {}

-- Forward declarations
local lookup_account,
      save_new_account,
      update_account_balance

function BankAccount.for_character(char_id, cb)
    lookup_account(char_id, function(baccount)
        cb(baccount)
    end)
end

function BankAccount.for_player(player_id, cb)
    local character = exports.characters:GetPlayerCharacter(player_id)

    lookup_account(character.id, function(baccount)
        cb(baccount)
    end)
end

function BankAccount:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function BankAccount:deposit(amount)
    self.balance = self.balance + amount

    if self.id then
        update_account_balance(self)
    else
        save_new_account(self)
    end

    return true
end

-- @local
function lookup_account(char_id, cb)
    MySQL.Async.fetchAll(
        "SELECT * FROM bank_accounts where character_id = @id",
        { ["@id"] = char_id },
        function(results)
            local baccount

            if #results > 0 then
                baccount = BankAccount:new(results[1])
            else
                baccount = BankAccount:new({
                    character_id = char_id,
                    balance      = 0
                })
            end

            cb(baccount)
        end
    )
end

-- @local
function save_new_account(account)
    MySQL.Async.insert(
        "INSERT INTO bank_accounts (created_at, character_id, balance) VALUES (NOW(), @id, @balance);",
        {
            ["@id"]      = account.character_id,
            ["@balance"] = account.balance
        },
        function(new_id)
            account.id = new_id
        end
    )
end

-- @local
function update_account_balance(account)
    MySQL.Async.execute(
        "UPDATE bank_accounts SET balance = @new_balance WHERE id = @id",
        {
            ["@new_balance"] = account.balance,
            ["@id"]          = account.id
        },
        function(rows_changed)
            if rows_changed == 0 then
                Citizen.Trace("Error trying to set balance = " .. account.balance .. " for bank account " .. account.id .. ".\n")
            end
        end
    )
end
