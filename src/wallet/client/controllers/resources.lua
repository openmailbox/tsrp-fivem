local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    StatSetInt(GetHashKey("MP0_WALLET_BALANCE"), 0, true)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
