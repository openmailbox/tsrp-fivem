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
