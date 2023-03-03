local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    local connected = GetPlayers()
    if #connected == 0 then return end

    local count = 0

    -- if we're restarting this live, give time for downstream resources to start
    Citizen.Wait(5000)

    for _, player in ipairs(connected) do
        local name  = GetPlayerName(player)

        Account.initialize(player, name, function(account)
            count = count + 1
            TriggerEvent(Events.ON_ACCOUNT_LOADED, { account = account })
        end)
    end

    if count > 0 then
        Logging.log(Logging.INFO, "Finished initializing " .. count .. " connected player accounts.")
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
