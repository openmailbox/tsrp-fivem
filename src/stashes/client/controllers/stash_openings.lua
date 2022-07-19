local function update(data)
    -- Any client-side processing to confirm the contents

    while GetGameTimer() < data.opened_at do
        Citizen.Wait(50)
    end

    TriggerServerEvent(Events.UPDATE_STASH_OPENING, data)
    Citizen.Wait(data.latency)

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("You found ~g~$" .. data.contents.cash .. "~s~.")
    EndTextCommandThefeedPostTicker(false, true)
end
RegisterNetEvent(Events.UPDATE_STASH_OPENING, update)
