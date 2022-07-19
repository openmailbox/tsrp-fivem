local function update(data)
    -- Any client-side processing to confirm the contents

    while GetGameTimer() < data.opened_at do
        Citizen.Wait(100)
    end

    -- Notifications

    TriggerServerEvent(Events.UPDATE_STASH_OPENING, data)
end
RegisterNetEvent(Events.UPDATE_STASH_OPENING, update)
