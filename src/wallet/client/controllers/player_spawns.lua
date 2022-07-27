local function create(_)
    TriggerServerEvent(Events.CREATE_WALLET_RESET)
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
