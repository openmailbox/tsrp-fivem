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

    if group == "COP" then
        GiveWeaponToPed(entity, GetHashKey("WEAPON_COMBATPISTOL"), 100, false, false)
        GiveWeaponToPed(entity, GetHashKey("WEAPON_NIGHTSTICK"), 0, false, false)
        SetPedArmour(entity, 50)
    elseif math.random() < 0.33 and string.match(group, "AMBIENT_GANG") then
        GiveWeaponToPed(entity, GetHashKey("WEAPON_PISTOL"), 100, false, false)
    end
end
AddEventHandler(Events.ON_ENTITY_CREATED, create)
