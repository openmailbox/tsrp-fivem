Inventory = {}

-- Forward declarations
local find_weapon_hash,
      get_equipment

local pending_actions = {}

function Inventory.process_action(data, callback)
    if IsPedDeadOrDying(PlayerPedId(), 1) then
        TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
            message = "You cannot use items while incapacitated."
        })

        callback({ success = false })
        return
    end

    local action = nil

    for k, v in pairs(ItemActions) do
        if string.lower(k) == string.lower(data.action) then
            action = v
            break
        end
    end

    if not action then
        Logging.log(Logging.WARN, "Inventory has no handler for action: " .. json.encode(data) .. ".")
        return
    end

    if action == ItemActions.USE then
        TriggerEvent(Events.CREATE_INVENTORY_ITEM_USE, { item = data.item })
    elseif action == ItemActions.DISCARD then
        TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, { item = data.item })
    elseif action == ItemActions.EQUIP then
        TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_EQUIP, {
            item        = data.item,
            weapon_hash = find_weapon_hash(data.item.name)
        })
    elseif action == ItemActions.UNEQUIP then
        TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_UNEQUIP, {
            item        = data.item,
            weapon_hash = find_weapon_hash(data.item.name)
        })
    end

    pending_actions[data.item.uuid] = callback

    Logging.log(Logging.TRACE, "Initiated action '" .. data.action .. "' on item " .. data.item.name .. " (" .. data.item.uuid .. ").")
end

function Inventory.refresh(data)
    local actions = { "use", "discard" }

    for _, container in pairs(data) do
        for _, item in ipairs(container.contents) do
            item.actions = actions
        end
    end

    SendNUIMessage({
        type       = Events.UPDATE_INVENTORY_REFRESH,
        containers = data,
        equipment  = get_equipment()
    })
end

function Inventory.resolve(item, action, success)
    local callback = pending_actions[item.uuid]
    if not callback then return end

    Logging.log(Logging.TRACE, "Resolved action " .. action .. " for item " .. item.uuid .. ".")

    pending_actions[item.uuid] = nil

    callback({ success = success })
end

-- @local
function find_weapon_hash(name)
    for hash, wname in pairs(WeaponLabels) do
        if wname == name then
            return hash
        end
    end

    return nil
end

-- @local
function get_equipment()
    local equipment = {}
    local actions   = { "unequip" }

    for name, weapons in pairs(WeaponSlots) do
        for _, weap in ipairs(weapons) do
            if HasPedGotWeapon(PlayerPedId(), weap, false) then
                equipment[name] = {
                    name    = WeaponLabels[weap], -- defined in @common/shared/weapons
                    label   = WeaponNames[weap],
                    actions = actions,
                    uuid    = GenerateUUID()
                }
            end
        end
    end

    return equipment
end
