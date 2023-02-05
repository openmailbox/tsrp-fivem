local function create(data)
    local entity  = NetToPed(data.net_id)
    local x, y, z = table.unpack(data.location)

    if Vdist(GetEntityCoords(entity), data.location) < 10.0 then
        TaskAimGunAtCoord(entity, x, y, z, -1, 0, 0)
    else
        TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 5.0, 0.0, true, 16, 1, -957453492)
    end
end
RegisterNetEvent(Events.CREATE_POPULATION_PED_TASK, create)
