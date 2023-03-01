Container = {}

-- player inventories
local players = {}

function Container.for_player(player_id)
    local container = players[tonumber(player_id)]

    if not container then
        container = Container:new({ contents = {} })
        players[tonumber(player_id)] = container
    end

    return container
end

function Container:new(o)
    o = o or {}
    o.contents = o.contents or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Container:add_item(item)
    table.insert(self.contents, item)
end
