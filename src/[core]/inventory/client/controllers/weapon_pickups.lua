local active  = false
local timeout = 0

-- Creates a weapon pickup in the vicinity of the player.
local function create(data)
    local x, y, z = table.unpack(data.location)
    local spot    = GetSafePickupCoords(x, y, z, 1.5, 1.5)
    local hash    = GetPickupHashFromWeapon(data.weapon)

    ToggleUsePickupsForPlayer(PlayerId(), hash, false)
    local pickup = CreatePickup(hash, spot.x, spot.y, spot.z, 0, 0, 0, data.weapon)

    timeout = GetGameTimer() + 1000

    repeat
        Citizen.Wait(100)
    until DoesPickupExist(pickup) or GetGameTimer() > timeout

    if not DoesPickupExist(pickup) then
        Logging.log(Logging.WARN, "Failed to create pickup for weapon " .. data.weapon .. " at " .. spot .. ".")
        return
    end

    Logging.log(Logging.TRACE, "Created pickup weapon " .. pickup .. " at " .. spot .. ".")

    ActivatePhysics(GetPickupObject(pickup))

    if active then return end
    active = true

    Citizen.CreateThread(function()
        while GetGameTimer() < timeout do
            Citizen.Wait(500)
        end

        active  = false
        timeout = 0

        ToggleUsePickupsForPlayer(PlayerId(), hash, true)
    end)
end
RegisterNetEvent(Events.CREATE_INVENTORY_WEAPON_PICKUP, create)
