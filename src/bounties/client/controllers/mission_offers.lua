local function delete(data, cb)
    if data.success then
        local target = Target.find_by_id(data.id)
        if target then target:activate() end
    else
        Target.cleanup()
        Maudes.reset()
    end

    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_BOUNTY_MISSION_OFFER, delete)

local function update(data)
    local target = Target.add_new(data)

    Citizen.CreateThread(function()
        local buffer = data.ui_target - GetCloudTimeAsInt() - data.ping

        if buffer > 0 then
            Citizen.Wait(math.max(2000, buffer))
        end

        SetNuiFocus(true, true)
        SendNUIMessage({
            type = Events.CREATE_BOUNTY_MISSION_OFFER,
            id   = target.id
        })
    end)
end
RegisterNetEvent(Events.UPDATE_BOUNTY_MISSION_OFFER, update)
