local function create(entity)
    if not DoesEntityExist(entity) then return end
    if GetEntityType(entity) ~= 1 then return end

    local group = Config.ModelGroups[GetEntityModel(entity)]
    if not group then return end

    local owner  = NetworkGetEntityOwner(entity)
    local net_id = NetworkGetNetworkIdFromEntity(entity)

    if not owner or owner == 0 then return end

    TriggerClientEvent(Events.UPDATE_ENTITY_RELGROUP, owner, {
        net_id = net_id,
        group  = group
    })

    TriggerEvent(Events.UPDATE_ENTITY_RELGROUP, {
        entity = entity,
        group  = group,
        owner  = owner,
        net_id = net_id
    })
end
AddEventHandler(Events.ON_ENTITY_CREATED, create)
