local function update(data)
    if not NetworkDoesEntityExistWithNetworkId(data.net_id) then return end

    local entity  = NetToPed(data.net_id)
    local loadout = data.loadout

    if loadout.driver_ability then
        SetDriverAbility(entity, loadout.driver_ability)
    end

    if loadout.combat_ability then
        SetPedCombatAbility(entity, loadout.combat_ability)
    end

    for _, attrib in ipairs(loadout.combat_attribs or {}) do
        SetPedCombatAttributes(entity, attrib, true)
    end

    if loadout.combat_movement then
        SetPedCombatMovement(entity, loadout.combat_movement)
    end

    if loadout.accuracy then
        SetPedAccuracy(entity, loadout.accuracy)
    end
end
RegisterNetEvent(Events.UPDATE_POPULATION_PED, update)
