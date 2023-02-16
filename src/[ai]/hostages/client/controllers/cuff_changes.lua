local function create(data)
    local entity = NetToPed(data.target)
    if not DoesEntityExist(entity) then return end

    Cuffs.initialize(entity, data.ping or 0)
end
RegisterNetEvent(Events.CREATE_CUFFED_HOSTAGE, create)

local function delete(data)
    local entity = NetToPed(data.target)
    if not DoesEntityExist(entity) then return end

    Cuffs.release(entity)
end
RegisterNetEvent(Events.DELETE_CUFFED_HOSTAGE, delete)
