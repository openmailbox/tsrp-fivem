local function create(data)
    while GetGameTimer() < data.opened_at do
        Citizen.Wait(50)
    end

    SetNuiFocus(true, true)

    SendNUIMessage({
        type = Events.CREATE_STASH_OPENING,
        data = data
    })
end
RegisterNetEvent(Events.CREATE_STASH_OPENING, create)

local function update(data, cb)
    TriggerServerEvent(Events.UPDATE_STASH_OPENING, {
        rewards = { data.selected }
    })

    local description = nil

    if data.selected.cash then
        description = "You found ~g~$" .. data.selected.cash .. "~s~."
    elseif data.selected.weapon then
        description = "You found a ~y~" .. data.selected.label .. "~s~."
    end

    if description then
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(description)
        EndTextCommandThefeedPostTicker(false, true)
    end

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.UPDATE_STASH_OPENING, update)
