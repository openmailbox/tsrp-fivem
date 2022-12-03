local LOCATIONS = {
    vector3(135.54, -1050.88, 28.254),
    vector3(1149.014, -1642.668, 35.431),
    vector3(-690.766, 512.382, 109.464),
    vector3(964.305, -1856.695, 30.297),
    vector3(146.85, 323.512, 111.239),
    vector3(518.521, 169.135, 98.469),
    vector3(173.869, 470.894, 141.007),
    vector3(-677.089, 902.166, 229.675),
    vector3(986.628, -139.113, 72.191),
    vector3(-1359.018, -756.869, 21.404),
    vector3(1967.323, 3821.04, 31.497),
    vector3(1204.583, -3118.73, 4.64)
}

local function create(data)
    local player_id = source
    local model     = data.model or GetHashKey(VehicleModels[math.random(#VehicleModels)])

    TriggerClientEvent(Events.UPDATE_CHOP_MISSION_OFFER, player_id, {
        model     = model,
        delivery  = LOCATIONS[math.random(#LOCATIONS)],
        ui_target = data.ui_target,
        ping      = GetPlayerPing(player_id),
        spawn     = data.spawn
    })
end
RegisterNetEvent(Events.CREATE_CHOP_MISSION_OFFER, create)
