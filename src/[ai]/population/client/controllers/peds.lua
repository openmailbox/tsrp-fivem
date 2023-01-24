local function update(data)
    if not NetworkDoesEntityExistWithNetworkId(data.net_id) then return end

    local entity = NetToPed(data.net_id)

    if data.driver_ability then
        SetDriverAbility(entity, data.driver_ability)
    end

    if data.combat_ability then
        SetPedCombatAbility(entity, data.combat_ability)
    end
end
RegisterNetEvent(Events.UPDATE_POPULATION_PED, update)
