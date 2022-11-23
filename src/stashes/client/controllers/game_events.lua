local function on_event(name, args)
    if name ~= Events.CLIENT_ENTITY_DAMAGE then return end

    local attacker = args[2]
    local is_dead  = args[6] == 1
    local weapon   = args[7]

    if is_dead and attacker == PlayerPedId() and weapon ~= Weapons.UNARMED then
        TriggerServerEvent(Events.CREATE_STASH_SCORE_EVENT, {
            weapon = WeaponLabels[weapon]
        })
    end
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
