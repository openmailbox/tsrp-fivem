local function create(data)
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityHealth(ped) + data.amount)
end
RegisterNetEvent(Events.CREATE_ADMIN_HP_ADJUST, create)
