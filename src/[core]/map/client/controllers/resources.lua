local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    WorldMap.initialize()
    PlayerMap.initialize()

    Citizen.CreateThread(function()
        while true do
            PlayerMap.current():update()
            Citizen.Wait(2000)
        end
    end)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)