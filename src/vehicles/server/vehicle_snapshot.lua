VehicleSnapshot = {}

function VehicleSnapshot.for_vehicle(vehicle)
    local snapshot = {}

    if GetIsVehiclePrimaryColourCustom(vehicle) then
        local r1, g1, b1 = GetVehicleCustomPrimaryColour(vehicle)
        local r2, g2, b2 = GetVehicleCustomSecondaryColour(vehicle)

        snapshot.color = {
            custom    = true,
            primary   = { r = r1, g = g1, b = b1 },
            secondary = { r = r2, g = g2, b = b2 }
        }
    else
        local primary, secondary = GetVehicleColours(vehicle)

        snapshot.color = {
            custom    = false,
            primary   = primary,
            secondary = secondary
        }
    end

    return snapshot
end
