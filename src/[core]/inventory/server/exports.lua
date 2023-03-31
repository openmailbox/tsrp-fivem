Exports = {}

function Exports.give_item_to_player(player_id, item_name)
    local container = Container.for_player(player_id)
    local template  = ItemTemplate.for_name(item_name)
    local item      = template and Item.from_template(template)

    if not item then
        return false
    end

    container:add_item(item)

    TriggerClientEvent(Events.UPDATE_INVENTORY_REFRESH, player_id, {
        inventory = container
    })
end
exports("GiveItemToPlayer", Exports.give_item_to_player)

function Exports.remove_item_from_player(player_id, item_uuid, quantity)
    local container = Container.for_player(player_id)
    return container and container:remove_item(item_uuid, quantity)
end
exports("RemoveItemFromPlayer", Exports.remove_item_from_player)
