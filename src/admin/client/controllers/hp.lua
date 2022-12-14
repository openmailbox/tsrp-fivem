local function create(data)
    local ped          = PlayerPedId()
    local armor        = GetPedArmour(ped)
    local prefer_armor = false

    if armor > 0 and data.amount > 0 then
        prefer_armor = true
    end

    -- TODO: Does NOT generate a CNetworkEventEntityDamage event. Needs investigation.
    ApplyDamageToPed(PlayerPedId(), data.amount, prefer_armor)
end
RegisterNetEvent(Events.CREATE_ADMIN_HP_ADJUST, create)
