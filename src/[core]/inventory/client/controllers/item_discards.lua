local pending = {}

local function create(data, cb)
    pending[data.item.uuid] = cb
    TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, data)
end
RegisterNUICallback(Events.CREATE_INVENTORY_ITEM_DISCARD, create)

local function update(data)
    local callback = pending[data.item_uuid]
    if not callback then return end

    pending[data.item_uuid] = nil
    callback(data)

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "Discarded ~y~" .. data.item_name .. "~s~."
    })
end
RegisterNetEvent(Events.UPDATE_INVENTORY_ITEM_DISCARD, update)
