local function create(data)
    local player_id = source
    local ped       = GetPlayerPed(player_id)

    if data.old == 0 and data.new > 0 then
        Dispatcher.new_call(GetEntityCoords(ped), {
            player_id = player_id
        })
    elseif data.old > 0 and data.new == 0 then
        local call_id = Dispatcher.find_call({ player_id = player_id })

        if call_id then
            Dispatcher.cancel(call_id)
        end
    end
end
RegisterNetEvent(Events.CREATE_WANTED_STATUS_CHANGE, create)
