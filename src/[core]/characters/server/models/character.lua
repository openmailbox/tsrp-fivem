Character = {}

local characters = {}
local next_id    = 1

function Character.for_account(id)
    return characters[id] or {}
end

function Character:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Character:save(callback)
    self.id = next_id
    next_id = next_id + 1

    local roster = characters[self.account_id]

    if not roster then
        roster = {}
        characters[self.account_id] = roster
    end

    table.insert(roster, self)

    callback(self)
end
