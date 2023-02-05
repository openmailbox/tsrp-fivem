local function create(entity)
    if not DoesEntityExist(entity) then return end
    if GetEntityType(entity) ~= 1 then return end

    local model   = GetEntityModel(entity)
    local loadout = Loadouts.for_model(model)
    local owner   = NetworkGetEntityOwner(entity)

    if not loadout then return end

    if loadout == Loadouts.Officer or loadout == Loadouts.Swat then
        local unit = PoliceUnit.for_entity(entity)

        if not unit then
            unit = PoliceUnit:new({ entity = entity })
            unit:initialize()
        end
    end

    for _, weap in ipairs(loadout.weapons) do
        GiveWeaponToPed(entity, weap, 100, false, false)
    end

    if loadout.armor then
        SetPedArmour(entity, loadout.armor)
    end

    if not owner or owner == 0 then return end

    TriggerClientEvent(Events.UPDATE_POPULATION_PED, owner, {
        net_id  = NetworkGetNetworkIdFromEntity(entity),
        loadout = loadout
    })
end
AddEventHandler(Events.ON_ENTITY_CREATED, create)

-- -2128726980 no task
-- 474215631 cower
