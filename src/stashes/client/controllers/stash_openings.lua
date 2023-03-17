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
        stash   = data.stash.stash_name,
        rewards = { data.selected }
    })

    local description = nil
    local stash       = Stash.find_by_name(data.stash.stash_name)

    if data.selected.cash then
        description = "You found ~g~$" .. data.selected.cash .. "~s~."
    elseif data.selected.weapon then
        description = "You found a ~y~" .. data.selected.name .. "~s~."
        Stash.show_bonus_help()
    elseif data.selected.armor then
        description = "You found some ~y~body armor ~s~."
    end

    if stash then
        stash:mark_opened()
        LestersHouse.reset()
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
