Character = {}

-- Forward declarations
local load_characters,
      save_new_character

function Character.for_account(id, callback)
    load_characters(id, callback)
end

function Character:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Character:save(callback)
    save_new_character(self, callback)
end

-- @local
function load_characters(account_id, cb)
    MySQL.Async.fetchAll(
        "SELECT * FROM characters WHERE account_id = @account_id",
        { ["@account_id"] = account_id },
        function(data)
            local results = {}

            for _, row in ipairs(data) do
                local char = Character:new(row)

                char.snapshot = json.decode(char.appearance)

                table.insert(results, char)
            end

            cb(results)
        end
    )
end

-- @local
function save_new_character(character, cb)
    MySQL.Async.insert(
        [[INSERT INTO characters (created_at, last_connect_at, account_id, first_name, last_name, appearance)
          VALUES (NOW(), NOW(), @account_id, @first_name, @last_name, @appearance);
        ]],
        {
            ["@account_id"] = character.account_id,
            ["@first_name"] = character.first_name,
            ["@last_name"]  = character.last_name,
            ["@appearance"] = json.encode(character.snapshot)
        },
        function(new_id)
            character.id = new_id
            cb(character)
        end
    )
end
