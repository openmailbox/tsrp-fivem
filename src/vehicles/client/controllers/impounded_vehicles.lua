local function update(data)
    local active = Impound.active()
    local lag    = data.ui_target - GetCloudTimeAsInt() - data.ping

    if lag > 0 then
        Citizen.Wait(lag)
    end

    active:show_vehicles(data.vehicles)
end
RegisterNetEvent(Events.UPDATE_IMPOUNDED_VEHICLES, update)
