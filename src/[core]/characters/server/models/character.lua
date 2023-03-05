Character = {}

-- Forward declarations
local load_characters,
      save_new_character,
      update_character

local characters = {} -- PlayerID->Character table of all active characters

function Character.for_account(id, callback)
    load_characters(id, callback)
end

function Character.for_player(id)
    return characters[id]
end
exports("GetPlayerCharacter", Character.for_player)

function Character:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Character:activate(player_id)
    self.player_id = player_id

    characters[player_id] = self

    MySQL.Async.execute("UPDATE characters SET last_connect_at = NOW() WHERE id = @id", { ["@id"] = self.id })
end

function Character:deactivate()
    characters[self.player_id] = nil
end

function Character:save(callback)
    if self.id then
        update_character(self)
    else
        save_new_character(self, callback)
    end
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


-- @local
function update_character(character)
    MySQL.Async.execute(
        [[UPDATE characters
          SET first_name = @first_name,
              last_name  = @last_name,
              appearance = @appearance
          WHERE id = @id]],
        {
            ["@first_name"] = character.first_name,
            ["@last_name"]  = character.last_name,
            ["@appearance"] = json.encode(character.snapshot),
            ["@id"]         = character.id
        },
        function(rows_changed)
            if rows_changed > 0 then
                Logging.log(Logging.TRACE, "Saved updates on Character " .. character.id .. ".")
            else
                Logging.log(Logging.WARN, "Unable to save updates on Character " .. character.id .. ": " .. json.encode(character) .. ".")
            end
        end
    )
end
