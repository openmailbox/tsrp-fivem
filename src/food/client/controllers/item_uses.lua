local function create(data)
    if not Consuming.can_consume(data.item) then return end
    Consuming.begin(data.item)
end
AddEventHandler(Events.CREATE_INVENTORY_ITEM_USE, create)
