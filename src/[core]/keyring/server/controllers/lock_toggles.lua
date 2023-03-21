-- Forward declarations
local toggle_vehicle_locks

local function create(data)
    local player_id = source
    local entity    = NetworkGetEntityFromNetworkId(data.entity)

    if entity == 0 then
        Logging.log(Logging.WARN, "Unable to find entity for net_id " .. data.entity .. ".")
        return
    end

    local etype = GetEntityType(entity)

    if etype == 2 then
        local has_key   = Keyring.check(entity, player_id)
        local new_value = nil
        local success   = nil

        if has_key then
            success   = true
            new_value = toggle_vehicle_locks(entity)
        else
            success = false
        end

        TriggerClientEvent(Events.UPDATE_KEYRING_LOCK_TOGGLE, player_id, {
            success   = success,
            entity    = data.entity,
            new_value = new_value
        })
    else
        Logging.log(Logging.WARN, GetPlayerName(player_id) .. " (" .. player_id .. ") toggled locks for " .. data.entity .. " with invalid entity type " .. etype .. ".")
    end
end
RegisterNetEvent(Events.CREATE_KEYRING_LOCK_TOGGLE, create)

-- @local
function toggle_vehicle_locks(entity)
    local current   = GetVehicleDoorLockStatus(entity)
    local new_value = nil

    if current > 1 then
        new_value = 1
    else
        new_value = 2
    end

    SetVehicleDoorsLocked(entity, new_value)

    return new_value
end
