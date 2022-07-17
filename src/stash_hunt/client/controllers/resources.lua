local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Stash.initialize()

    SetMultiplayerWalletCash()
    SetMultiplayerBankCash()

    Citizen.Wait(3000)

    RemoveMultiplayerWalletCash()
    RemoveMultiplayerBankCash()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Event.cleanup()
    Stash.cleanup()
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
