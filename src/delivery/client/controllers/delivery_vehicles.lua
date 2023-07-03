local function update(data)
    local route = Route.get_active()
    if not route then return end

    route.vehicle = NetToVeh(data.net_id)
end
RegisterNetEvent(Events.UPDATE_DELIVERY_VEHICLE, update)