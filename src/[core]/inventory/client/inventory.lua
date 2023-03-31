Inventory = {}

-- Forward declarations
local find_weapon_hash,
      get_ammo_details,
      get_equipment,
      get_weapon_details,
      has_tag

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
        TriggerEvent(Events.CREATE_INVENTORY_ITEM_USE, { item = data.item, quantity = data.quantity })
    elseif action == ItemActions.DISCARD then
        TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_DISCARD, { item = data.item, quantity = data.quantity })
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
            local template = ItemTemplate.for_name(item.name)

            if has_tag(template, "equipment") then
                item.actions = { "equip", "discard" }
                item.details = get_weapon_details(template.hash)
            elseif has_tag(template, "ammunition") then
                item.actions = actions
                item.details = get_ammo_details(template.hash)
            else
                item.actions = actions
            end
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
    for hash, wname in pairs(WeaponNames) do
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

    for slot, weapons in pairs(WeaponSlots) do
        for _, weap in ipairs(weapons) do
            if HasPedGotWeapon(PlayerPedId(), weap, false) then
                local name     = WeaponNames[weap] -- defined in @common/shared/weapons
                local template = ItemTemplate.for_name(name)

                if not template then
                    Logging.log(Logging.WARN, "Unable to find item template for weapon '" .. name .. "'.")
                end

                equipment[slot] = {
                    name        = WeaponLabels[weap],
                    description = (template and template.description) or '',
                    label       = name,
                    actions     = actions,
                    uuid        = GenerateUUID(),
                    details     = get_weapon_details(template and template.hash)
                }
            end
        end
    end

    return equipment
end

-- @local
function get_ammo_details(hash)
    local ammo    = GetPedAmmoByType(PlayerPedId(), hash)
    local _, max  = GetMaxAmmoByType(PlayerPedId(), hash)
    local details = {}

    table.insert(details, {
        label = "Equipped",
        text  = tostring(ammo) .. " / " .. max
    })

    return details
end

-- @local
function get_weapon_details(hash)
    if not IsWeaponValid(hash) then return end

    local max_clip = GetMaxAmmoInClip(PlayerPedId(), hash, 1)
    local details  = {}

    if max_clip == 0 then return end

    table.insert(details, {
        label = "Magazine",
        text  = max_clip
    })

    return details
end

-- @local
function has_tag(item, target)
    if not item then
        return false
    end

    for _, tag in ipairs(item.tags or {}) do
        if tag == target then
            return true
        end
    end

    return false
end
