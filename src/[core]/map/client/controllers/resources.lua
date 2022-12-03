local next_snapshot = 0

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    WorldMap.initialize()
    PlayerMap.initialize()

    Citizen.CreateThread(function()
        local time

        while true do
            Citizen.Wait(2000)

            time = GetGameTimer()

            PlayerMap.current():update()

            if time > next_snapshot then
                next_snapshot = time + 10000
                Snapshot.record()
            end
        end
    end)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
