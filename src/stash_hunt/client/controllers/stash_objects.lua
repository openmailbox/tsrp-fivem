local function create(data)
    if not HasModelLoaded(data.model) then
        RequestModel(data.model)

        while not HasModelLoaded(data.model) do
            Citizen.Wait(5)
        end
    end

    TriggerServerEvent(Events.CREATE_STASH_OBJECT, data)
end
RegisterNetEvent(Events.CREATE_STASH_OBJECT, create)

local function update(data)
    local object = NetToObj(data.net_id)
    ActivatePhysics(object)
    SetModelAsNoLongerNeeded(GetEntityModel(object))
end
RegisterNetEvent(Events.UPDATE_STASH_OBJECT, update)
