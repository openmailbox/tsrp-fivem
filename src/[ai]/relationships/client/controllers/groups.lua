local function update(data)
    if not NetworkDoesEntityExistWithNetworkId(data.net_id) then return end

    local entity = NetToPed(data.net_id)

    if not entity or entity == 0 then return end

    if data.temporary then
        SetPedRelationshipGroupHash(entity, GetHashKey(data.group))
    else
        SetPedRelationshipGroupDefaultHash(entity, GetHashKey(data.group))
    end
end
RegisterNetEvent(Events.UPDATE_ENTITY_RELGROUP)
AddEventHandler(Events.UPDATE_ENTITY_RELGROUP, update)
