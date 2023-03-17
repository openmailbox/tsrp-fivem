-- Handles what to do when player encounters a weapon pickup.
local function on_event(ename, args)
    if ename ~= Events.CLIENT_PLAYER_COLLECT_PICKUP then return end

    local name  = nil
    local weapon = nil

    for _, v in pairs(Weapons) do
        if GetPickupHashFromWeapon(v) == args[3] then
            name   = WeaponNames[v]
            weapon = v
            break
        end
    end

    if not weapon then
        Logging.log(Logging.WARN, "Picked up an unidentified pickup hash: " .. args[3] .. ".")
        return
    end

    local template = ItemTemplate.for_name(name)

    if not template then
        Logging.log(Logging.WARN, "Picked up weapon hash without item template for " .. name .. ".")
        return
    end

    -- We want picked up weapons to go straight to inventory not equipment.
    RemoveWeaponFromPed(PlayerPedId(), weapon)

    TriggerServerEvent(Events.CREATE_INVENTORY_WEAPON_PICKUP, {
        weapon = name
    })

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "You picked up one ~y~" .. name .. "~s~."
    })

    Logging.log(Logging.TRACE, "Picked up one " .. name .. ".")
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
