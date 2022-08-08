local function mod_weapon(source, _, _)
    TriggerClientEvent(Events.CREATE_WEAPONSMITH_SESSION, source)
end
RegisterCommand("modweapon", mod_weapon, true)
