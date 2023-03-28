Container = {}

-- Forward declarations
local can_stack_items

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

function Container:add_item(new_item)
    for _, item in ipairs(self.contents) do
        if can_stack_items(item, new_item) then
            item.quantity = item.quantity + new_item.quantity
            return
        end
    end

    new_item.uuid = GenerateUUID()

    table.insert(self.contents, new_item)
end

function Container:remove_item(uuid, quantity)
    quantity = quantity or 1

    for i, item in ipairs(self.contents) do
        if item.uuid == uuid then
            if quantity < (item.quantity or 1) then
                item.quantity = item.quantity - quantity
            else
                table.remove(self.contents, i)
            end

            return item
        end
    end

    return nil
end

-- @local
function can_stack_items(first_item, second_item)
    if first_item.name ~= second_item.name then
        return false
    end

    for _, tag in ipairs(first_item.tags or {}) do
        if tag == "equipment" then
            return false
        end
    end

    return true
end
