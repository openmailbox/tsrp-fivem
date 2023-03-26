local function index(data)
    local player_id = source

    Vehicle.from_impound(player_id, function(vehicles)
        TriggerClientEvent(Events.UPDATE_IMPOUNDED_VEHICLES, player_id, {
            vehicles  = vehicles,
            ui_target = data.ui_target,
            ping      = GetPlayerPing(player_id)
        })
    end)
end
RegisterNetEvent(Events.GET_IMPOUNDED_VEHICLES, index)
