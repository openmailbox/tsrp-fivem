-- Triggered from client when player hits a weapon pickup.
local function create(data)
    local player_id = source
    local container = Container.for_player(player_id)
    local template  = ItemTemplate.for_name(data.weapon)
    local item      = Item.from_template(template)

    container:add_item(item)
end
RegisterNetEvent(Events.CREATE_INVENTORY_WEAPON_PICKUP, create)
