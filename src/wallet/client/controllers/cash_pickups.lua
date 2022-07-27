local active  = false
local timeout = nil

-- Triggered by something server-side to spawn collectible cash objects.
local function create(data)
    local x, y, z = table.unpack(data.location)
    local spot    = GetSafePickupCoords(x, y, z, 0, 0)

    timeout = GetGameTimer() + ((data.timeout or 0) * 1000)

    ToggleUsePickupsForPlayer(PlayerId(), Objects.CASH_PICKUP, false)
    CreateMoneyPickups(spot.x, spot.y, spot.z, data.amount, math.ceil(data.amount / 10000), Objects.CASH_PICKUP)

    if active then return end
    active = true

    Citizen.CreateThread(function()
        while GetGameTimer() < timeout do
            Citizen.Wait(1000)
        end

        active  = false
        timeout = nil

        ToggleUsePickupsForPlayer(PlayerId(), Objects.CASH_PICKUP, true)
    end)
end
RegisterNetEvent(Events.CREATE_CASH_PICKUP, create)
