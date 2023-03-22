local function create(entity)
    if not DoesEntityExist(entity) then return end
    if GetEntityType(entity) ~= 1 then return end

    local x, y, _ = table.unpack(GetEntityCoords(entity))
    local zones   = Zone.from_point(x, y)

    if #zones == 0 then return end

    local restricted = false

    for _, zone in ipairs(zones) do
        if zone.restricted then
            restricted = true
            break
        end
    end

    if not restricted then return end

    local owner  = NetworkGetEntityOwner(entity)
    local net_id = NetworkGetNetworkIdFromEntity(entity)

    if not owner or owner == 0 then return end

    TriggerClientEvent(Events.UPDATE_ENTITY_RELGROUP, owner, {
        net_id    = net_id,
        group     = "AGGRESSIVE_INVESTIGATE",
        temporary = true
    })
end
AddEventHandler(Events.ON_ENTITY_CREATED, create)
