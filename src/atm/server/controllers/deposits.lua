local function create(data)
    local player_id = source

    Citizen.Wait(2000)

    TriggerClientEvent(Events.UPDATE_ATM_DEPOSIT, player_id, {
        success = false,
        error   = "Test error."
    })
end
RegisterNetEvent(Events.CREATE_ATM_DEPOSIT, create)
