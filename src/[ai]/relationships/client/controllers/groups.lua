local function update(data)
    local entity = NetToPed(data.net_id)

    if entity and entity > 0 then
        if data.temporary then
            SetPedRelationshipGroupHash(entity, GetHashKey(data.group))
        else
            SetPedRelationshipGroupDefaultHash(entity, GetHashKey(data.group))
        end
    else
        Citizen.Trace("Unable to locate entity for " .. data.net_id .. ".\n")
    end
end
RegisterNetEvent(Events.UPDATE_ENTITY_RELGROUP)
AddEventHandler(Events.UPDATE_ENTITY_RELGROUP, update)
