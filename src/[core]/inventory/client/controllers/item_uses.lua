local pending = {}

local function create(data, cb)
    if IsPedDeadOrDying(PlayerPedId(), 1) then
        TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
            message = "You cannot use items while incapacitated."
        })

        cb({ success = false })
        return
    end

    pending[data.item.uuid] = cb
    TriggerEvent(Events.CREATE_INVENTORY_ITEM_USE, data)
end
RegisterNUICallback(Events.CREATE_INVENTORY_ITEM_USE, create)

local function update(data)
    local callback = pending[data.item_uuid]
    if not callback then return end

    pending[data.item_uuid] = nil
    callback(data)
end
AddEventHandler(Events.UPDATE_INVENTORY_ITEM_USE, update)
