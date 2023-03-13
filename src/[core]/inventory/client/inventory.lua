Inventory = {}

-- Forward declarations
local get_action

local ItemActions = {
    USE     = 1,
    DISCARD = 2
}

local ACTION_LABELS = {
    [ItemActions.USE]     = "Use",
    [ItemActions.DISCARD] = "Discard"
}

local pending_actions = {}

function Inventory.process_action(data, callback)
    if IsPedDeadOrDying(PlayerPedId(), 1) then
        TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
            message = "You cannot use items while incapacitated."
        })

        callback({ success = false })
        return
    end

    local action = get_action(data.modifiers)

    if not action then
        Logging.log(Logging.WARN, "Inventory has no handler for action: " .. json.encode(data) .. ".")
        return
    end

    pending_actions[data.item.uuid] = callback

    if action == ItemActions.USE then
        TriggerEvent(Events.CREATE_INVENTORY_ITEM_USE, { item = data.item })
    elseif action == ItemActions.DISCARD then
        TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, data)
    end

    Logging.log(Logging.TRACE, "Initiated action " .. ACTION_LABELS[action] .. " on item " .. data.item.name .. " (" .. data.item.uuid .. ").")
end

function Inventory.refresh(data)
    local labels = {}

    for _, label in pairs(ACTION_LABELS) do
        table.insert(labels, label)
    end

    for _, container in pairs(data) do
        for _, item in ipairs(container.contents) do
            item.actions = labels
        end
    end

    SendNUIMessage({
        type       = Events.UPDATE_INVENTORY_REFRESH,
        containers = data
    })
end

function Inventory.resolve(data)
    local callback = pending_actions[data.item_uuid]
    if not callback then return end

    Logging.log(Logging.TRACE, "Resolved action for item " .. data.item_uuid .. ".")

    pending_actions[data.item_uuid] = nil
    callback(data)
end

-- @local
function get_action(inputs)
    local index = 1

    for _, v in pairs(inputs) do
        if v then
            index = index + 1
        end
    end

    for _, v in pairs(ItemActions) do
        if v == index then
            return v
        end
    end

    return nil
end
