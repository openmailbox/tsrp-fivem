local function update(data)
    Inventory.resolve(data)

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "Discarded ~y~" .. data.item_name .. "~s~."
    })
end
RegisterNetEvent(Events.UPDATE_INVENTORY_ITEM_DISCARD, update)
