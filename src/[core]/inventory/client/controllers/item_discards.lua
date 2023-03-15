local function update(data)
    Inventory.resolve({ uuid = data.item_uuid }, ItemActions.DISCARD, data.success)

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "Discarded ~y~" .. data.item_name .. "~s~."
    })
end
RegisterNetEvent(Events.UPDATE_INVENTORY_ITEM_DISCARD, update)
