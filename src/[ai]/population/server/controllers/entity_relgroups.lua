-- Triggered by relationships resource when a newly spawned ped is assigned to a configured relationship group.
local function update(data)
    if data.group == "COP" then
        GiveWeaponToPed(data.entity, GetHashKey("WEAPON_COMBATPISTOL"), 100, false, false)
        GiveWeaponToPed(data.entity, GetHashKey("WEAPON_NIGHTSTICK"), 0, false, false)
        SetPedArmour(data.entity, 75)
    elseif string.match(data.group, "AMBIENT_GANG") and math.random() < 0.33 then
        GiveWeaponToPed(data.entity, GetHashKey("WEAPON_PISTOL"), 100, false, false)
    end

    TriggerClientEvent(Events.UPDATE_POPULATION_PED, data.owner, {
        net_id         = data.net_id,
        driver_ability = 1.0,
        combat_ability = 2
    })
end
AddEventHandler(Events.UPDATE_ENTITY_RELGROUP, update)
