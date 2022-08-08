local function create()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        return false
    end

    if GetCurrentPedWeapon(PlayerPedId(), Weapons.UNARMED, 1) then
        return false
    end
end
RegisterNetEvent(Events.CREATE_WEAPONSMITH_SESSION, create)
